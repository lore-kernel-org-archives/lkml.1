Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXBJM5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXBJM5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 07:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXBJM5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 07:57:49 -0500
Received: from ag-out-0708.google.com ([72.14.246.246]:33017 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbXBJM5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 07:57:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dNlHtFzB2ChOajQl+8SG3TE8iXMtls5sU32Wun90vVJdbJDt9hfNbgt0mqaMSS4Cl9A6rUCghGD7wHWd+flWi8kS6DU58H/vqcAYPD41HQOAXg8CtE1mE3hsTtpBDzVoqmY1UWYi1vVZSjIntBW3YiC7Z4VSY1eUFMgROZYsRc0=
Message-ID: <ee9e417a0702100457s6ed2c6a3sd5cc45a21db69876@mail.gmail.com>
Date: Sat, 10 Feb 2007 07:57:46 -0500
From: "Russ Cox" <rsc@swtch.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] fix quadratic behavior of shrink_dcache_parent()
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HFnsK-0007Ep-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HFdnm-0006DB-00@dorka.pomaz.szeredi.hu>
	 <20070209160055.bbd20c9f.akpm@linux-foundation.org>
	 <ee9e417a0702091623t1ccf55b8wb05b64b9c51474a6@mail.gmail.com>
	 <E1HFnsK-0007Ep-00@dorka.pomaz.szeredi.hu>
X-Google-Sender-Auth: f83ef1cee397e096
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Unfortunately this patch doesn't completely solve this problem, since
> the system will still be hosed due to all memory being used up by
> dentries.  And I bet the OOM killer won't find the real target (du)
> but will kill anything before that.
>
> So the second part of the problem is to somehow limit the number of
> dentries used.  Not easy...

At least with this patch (if I am reading it correctly), once the offending
culprit is identified and the programs are killed off, everything will go
back to normal without a reboot.

Russ
