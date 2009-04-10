Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbZDJUrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbZDJUrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760365AbZDJUrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:47:09 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59255 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbZDJUrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=naeWhGDMeT9DLmyJwBZw8DACz7+9MMynisGboUGn+Xh3YMdQ/rKKXKKCPPW9fB1pbc
         9lKVw6CubUIuaNMS+t24wToJs4U1RzigGouvgnYz3xyMR0jRSTstr6puvCRdE0uQMqHj
         /7Z0mmx2NkQ6O9F2Blxv8JbBe4Wh7piTncTmI=
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239395434.13792.3.camel@maxim-laptop>
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)  <1239110010.22453.41.camel@johannes.local>
	 <1239110412.15015.23.camel@maxim-laptop>
	 (sfid-20090407_152021_060436_AEF9110F)  <1239110860.4084.0.camel@johannes.local>
	 <1239112310.15015.25.camel@maxim-laptop>
	 <1239135878.17958.11.camel@maxim-laptop>
	 (sfid-20090407_222443_633750_085B264D)  <1239136637.7475.57.camel@johannes.local>
	 <1239395434.13792.3.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 23:47:01 +0300
Message-Id: <1239396421.13792.6.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 23:30 +0300, Maxim Levitsky wrote:
> On Tue, 2009-04-07 at 22:37 +0200, Johannes Berg wrote:
> > On Tue, 2009-04-07 at 23:24 +0300, Maxim Levitsky wrote:
> > 
> > > First I get this in kernel logs:
> > > 
> > > 
> > > > [   29.971903] WARNING:
> > > at /home/maxim/software/kernel/linux-2.6/net/wireless/core.h:79
> > > nl80211_send_wiphy+0x8bd/0xa20 [cfg80211]()
> > 
> > Eh, I don't think that is present in a recent wireless tree.
> 
> It is.
> 
> I have just compiled iwlwifi.git tree, and same message is there:


And I found out why device is always busy, when wpa supplicant tries to
scan. It is the disassociation sequence.

Does kernel notify, when disassociation have finished?
Maybe it is still better not to fail scan request, but block?

Best regards,
	Maxim Levitsky

