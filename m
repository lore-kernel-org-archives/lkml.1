Return-Path: <linux-kernel-owner+w=401wt.eu-S1161137AbXDQRYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161137AbXDQRYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161126AbXDQRYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:24:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:12391 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137AbXDQRYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ElBqnEWzAHrGVnc215VmKfyxCPRFqwDKLOGgNLENeeGD0LmnCu++bFA9mfPAAJXyOx7QthIxZ/MpHzsYMaufpdfOamqpzgbEp1nmjT+k9W5WeNuN9vYz1PzvOEMCyVeloBXbcMSNQ7WAMPqIM+zV0AEeaUQhltC/Kb/SBtXiC+Y=
Message-ID: <38b2ab8a0704171024m3d838bdak14370a7d0931557f@mail.gmail.com>
Date: Tue, 17 Apr 2007 19:24:04 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <ada7isb3qr2.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	 <E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	 <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
	 <adairbv57s2.fsf@cisco.com>
	 <38b2ab8a0704170914h3a766236t47bc7e1c8de67662@mail.gmail.com>
	 <ada7isb3qr2.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/17/07, Roland Dreier <rdreier@cisco.com> wrote:
>  > > I wonder if there's some way you can cache the last caller and reload
>  > > the key lazily (only when it changes).
>  >
>  > yes something that allows crypto drivers to detect if the key has
>  > changed would be good.
>
> It seems trivial to keep the last key you were given and do a quick
> memcmp in your setkey method to see if it's different from the last
> key you pushed to hardware, and set a flag if it is.  Then only do
> your set_key() if you have a new key to pass to hardware.
>
> I'm assuming the expense is in the aes_write() calls, and you could
> avoid them if you know you're not writing something new.
>

that's a wrong assumption. aes_write()/aes_read() are both used to
access to the controller and are slow (no cache involved).

thanks
-- 
Francis
