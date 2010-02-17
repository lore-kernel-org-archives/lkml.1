Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab0BQMsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 07:48:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757115Ab0BQMsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 07:48:10 -0500
Message-ID: <4B7BE561.3070403@redhat.com>
Date: Wed, 17 Feb 2010 14:47:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, hpa@zytor.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] x86: add support for multiple choice alternatives
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com> <1266406962-17463-2-git-send-email-luca@luca-barbieri.com>
In-Reply-To: <1266406962-17463-2-git-send-email-luca@luca-barbieri.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2010 01:42 PM, Luca Barbieri wrote:
> This patch modifies the x86 alternative macros to allow more than one
> alternative code sequence.
>
> This is done by simply adding multiple alternative patches, which are
> applied in sequence, overwriting previous ones.
>
> +/* alternative assembly primitive: */
> +#define ALTERNATIVE(oldinstr, newinstr, feature)			\
> +      "661:\n\t" oldinstr "\n662:\n"					\
> +      ALTERNATIVE_PATCH("661b", "662b", newinstr, feature)
> +
> +#define ALTERNATIVE3(oldinstr, newinstr1, feature1, newinstr2, feature2)			\
> +      "661:\n\t" oldinstr "\n662:\n"					\
> +      ALTERNATIVE_PATCH("661b", "662b", newinstr1, feature1) "\n" \
> +      ALTERNATIVE_PATCH("661b", "662b", newinstr2, feature2)
> +
> +#define ALTERNATIVE4(oldinstr, newinstr1, feature1, newinstr2, feature2, newinstr3, feature3)			\
> +      "661:\n\t" oldinstr "\n662:\n"					\
> +      ALTERNATIVE_PATCH("661b", "662b", newinstr1, feature1) "\n" \
> +      ALTERNATIVE_PATCH("661b", "662b", newinstr2, feature2) "\n" \
> +      ALTERNATIVE_PATCH("661b", "662b", newinstr3, feature3)
> +
>    

Suggest documenting the precedence of alternatives: if both feature1 and 
feature2 are present, which newinstr is patched in?

-- 
error compiling committee.c: too many arguments to function

