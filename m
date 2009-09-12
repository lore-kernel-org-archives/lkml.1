Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZILSt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZILSt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 14:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbZILSt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 14:49:28 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34496 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZILSt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 14:49:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hmSqaVZ4mlzazQ1l7i2cnTe2RwG0mpwlUR56LWZv+NjxObYQIMYcfkx53EQTTb4cMx
         WnT60ApvpgzInQk3Q52iHKwxxcvKLjO3KFGUzhQp7Tsax4r38SGq+F4zi4b4m2kuHCOp
         2Ux8vdyIpMP9qut/ph5+WNg7Qau15Jl495QZ0=
Date: Sat, 12 Sep 2009 22:49:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Ingo Molnar <mingo@elte.hu>, Julia Lawall <julia@diku.dk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: apic: convert BUG() to BUG_ON()
Message-ID: <20090912184929.GB4893@lenovo>
References: <1252777220-30796-1-git-send-email-dwalker@fifo99.com> <20090912180527.GA4893@lenovo> <1252779641.28368.81.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252779641.28368.81.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Daniel Walker - Sat, Sep 12, 2009 at 11:20:41AM -0700]
| On Sat, 2009-09-12 at 22:05 +0400, Cyrill Gorcunov wrote:
| 
| > 
| > Hi Daniel,
| > 
| > I believe having a changelog like
| > 
| > 	Use short form of "if() BUG()" sequence
| > 
| > would be better perhaps? Since "Coccinelle's BUG_ON semantic patch"
| > somehow doesn't describe why it's done.
| > 
| > Don't get me wrong please. It's trivial and seen from patch
| > itself _why_ it's done though changelog doesn't say the same.
| > 
| > Perhaps I'm too nagging :) Feel free to ignore me.
| 
| Not nagging, I wondered myself what the benefit was when I ran
| Coccinelle.
| 
| For one it condenses duplicate code (i.e. the if()). If the BUG_ON()
| macro gets updated with something new, all the users get the updates
| automatically. The other thing is your re-using potentially more
| advanced code that's inside the macro. In this case it's fairly trivial,
| 
| #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
| 
| So we're getting the benefit on the new "unlikely" in the apic code.
| unlikely/likely calls will usually allow the compiler to create smaller,
| and or, more optimized code. 

I would not relay on "unlikely" much especially in apic code.
Though on some platforms this apic_id_registered returns plain 1
which could (didn't check myself) bring in some optimization
(to be fair -- I can't imagine what could be optimized
 in this particular case, especially since we may have locked
 operations on mem write).

So I consider it as code shrinking on source level only :)

| 
| So there are at least two benefits, and I don't see any downside to it.
| 
| Daniel
| 
	-- Cyrill
