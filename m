Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYK2N1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYK2N1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 08:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYK2N1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 08:27:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:8613 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYK2N1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 08:27:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BYdGLduPsOjrzuFKgDpwgGbaQ1EnbQPvFwVcZ/xvK+TbkRqkRxOOwYXdnBJln9Sp3p
         YaC6FKUx5ealOIZYa+Uellwq9YSTlc4yQtjt8vsrkf/wZAxcdUIbU+Epe5tZXZQT6AHK
         SLS4QY6Xrg1+OqoodwS0sjwqFuKEJXkplUNYs=
Message-ID: <49314334.6060609@gmail.com>
Date: Sat, 29 Nov 2008 08:27:16 -0500
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: powerpc: hv{cs,si}_close() both unsigned hp->count and hvcsd->open_count
 cannot be negative
References: <4931201D.7060701@gmail.com> <jey6z24rqw.fsf@sykes.suse.de>
In-Reply-To: <jey6z24rqw.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> roel kluin <roel.kluin@gmail.com> writes:
> 
>> -	if (--hvcsd->open_count == 0) {
>> +	if (hvcsd->open_count == 1) {
>> +		hvcsd->open_count--;
> 
> This is not the same.

I think you're missing that I also decrement if (hvcsd->open_count > 1)
If not, please elaborate.

> 
>> -	if (--hp->count == 0) {
>> +	if (hp->count == 1) {
>> +		hp->count--;
> 
> Likewise.

Same here.

Roel
