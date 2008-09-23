Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbYIWUdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbYIWUdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYIWUdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:33:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:41341 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYIWUdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jkcehGv2EuKLliiFv3Tp3vGiHwoA19f/+9U9Pv2ausog8TtkVnHd8K38WreBltq56c
         pPWvrIbnWW6AxwTqt1gGzmqrXgEc24cfcf5jLea3drizE/IzvN4Y8jq4e70ZsmoadDOE
         W/h7CJqlV0vq5tsVGsV6oy0sw7HFNX32cliWo=
Message-ID: <a4e6962a0809231333x48c1d4b8t1b18eae40cd148ee@mail.gmail.com>
Date: Tue, 23 Sep 2008 15:33:14 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Abhishek Kulkarni" <kulkarni@lanl.gov>
Subject: Re: [PATCH] 9p bug fix: return non-zero error value in p9_put_data
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1220382298.14226.4.camel@blender>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219771831.16125.12.camel@blender>
	 <a4e6962a0808281110s6ee6c86ak3ff6e28c51981656@mail.gmail.com>
	 <1219948516.2678.16.camel@blender> <1220382298.14226.4.camel@blender>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey - first of all, sorry for the long delay on responding to this,
I've just gotten back to my patch queue.

On Tue, Sep 2, 2008 at 2:04 PM, Abhishek Kulkarni <kulkarni@lanl.gov> wrote:
> Resubmitting my previous 9p bug fix patch that removes the bogus return
> value in p9_put_data which made every p9_client_write fail.
>
> Signed-off-by: Abhishek Kulkarni <kulkarni@lanl.gov>
> ---

Please include the original description when resubmitting patches --
this will allow me to suck it into my tree more effectively.

>
> -static int
> +static void
>  p9_put_data(struct cbuf *bufp, const char *data, int count,
>                   unsigned char **pdata)
>  {
>        *pdata = buf_alloc(bufp, count);
>        memmove(*pdata, data, count);
> -       return count;
>  }
>

What happens if buf_alloc returns NULL?

Isn't the right behavior something more along the lines of:

static int
p9_put_data(struct cbuf *bufp, const char *data, int count,
                   unsigned char **pdata)
{
        *pdata = buf_alloc(bufp, count);'
        if(*pdata)
            memmove(*pdata, data, count);
            return 0;
        else
            return ENOMEM;
}

                  -eric
