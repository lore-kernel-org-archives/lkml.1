Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbYEGTeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbYEGTeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758397AbYEGTeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:34:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:57869 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbYEGTd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=I9wvPjpXRl10g+b0VgXHfyHJ/GwidbzigRywuGfU9dvB2RgH2spzDfCCnVeyF8Umkx3afxFphAiRXtFT0UfGFl4AI/IR4GuQ47H6jkrO+MpUzE/n/1C7SyjSZRgBa67n4lcEI51AJqA/RSjWCjpWpL1ZCIOhYVUJap9xeHjHyr4=
Message-ID: <84144f020805071233u5ebaaa4fgfd6beccd36c873f0@mail.gmail.com>
Date: Wed, 7 May 2008 22:33:57 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Soumyadip Das Mahapatra" <dip_kernel@yahoo.co.in>
Subject: Re: [PATCH]: improved strnicmp in lib/string.c
Cc: linux-kernel@vger.kernel.org, "Alexey Dobriyan" <adobriyan@gmail.com>
In-Reply-To: <116786.40929.qm@web94104.mail.in2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <116786.40929.qm@web94104.mail.in2.yahoo.com>
X-Google-Sender-Auth: 1792e6319c0f8b3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 9:21 PM, Soumyadip Das Mahapatra
<dip_kernel@yahoo.co.in> wrote:
>   int strnicmp(const char *s1, const char *s2, size_t len)
>   {
>  +    /* Yes, i am keeping 'em unsigned too */
>  +    unsigned char c1, c2, c3, c4;
>  +    unsigned count = 0;
>  +    int flag = -1;
>  +
>  +    c1 = c2 = c3 = c4 = 0;
>  +
>  +    if(len > 0)
>  +    {
>  +        for(; count <= len/2; count++)
>  +        {
>  +            c1 = tolower(s1[count]);    // well, we
>  +            c2 = tolower(s2[count]);    // are ignoring
>  +            c3 = tolower(s1[len-count-1]);    // cases
>  +            c4 = tolower(s2[len-count-1]);    // thats why
>  +
>  +            if(c1 == c2)
>  +            {
>  +                if(c3 != c4)
>  +                {
>  +                    flag = 1;
>  +                    break;
>  +                }
>  +            }
>  +            else
>                  break;
>  -        } while (--len);
>  +            flag = 0;

Unconditionally setting flag to zero in the loop also broken. For
example, comparing "hello" and "he9lo" resunts into zero now.

>  +        }
>      }
>  -    return (int)c1 - (int)c2;
>  -}
>  +    return flag;     // return 0 for matching and
>  +}            // nonzero for mismatch
>   EXPORT_SYMBOL(strnicmp);
>   #endif
>
>
>
>       Meet people who discuss and share your passions. Go to http://in.promos.yahoo.com/groups/bestofyahoo/
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
