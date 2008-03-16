Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYCPSS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYCPSS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbYCPSSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:18:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:55751 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbYCPSSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:18:43 -0400
X-Sasl-enc: +VH+yaxLRJand/h9nYCeQ1Tmw3rW51IBPwMIiqYKawaE 1205691522
Date: Sun, 16 Mar 2008 15:18:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: =?iso-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] LED updates
Message-ID: <20080316181840.GG19825@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com> <20080207213845.GA27862@khazad-dum.debian.net> <1202422388.9519.123.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202422388.9519.123.camel@dax.rpnet.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008, Richard Purdie wrote:
> > > Richard Purdie:
> > >       leds: Standardise LED naming scheme
> > 
> > This one causes trouble (at least on 2.6.23 -- I backported the patch) due
> > to the 20-byte length limit on sysfs names.  I had to use "tp::<somecrap>"
> > instead of "thinkpad::<somecrap>" to name LEDs, and still had to reduce
> > ultrabase_battery to ultrabase_batt :-)
> > 
> > Anyway, IMHO, the LED function should come first, and we should not even
> > need the led driver name anywhere.  In case of clashes in the class sysfs
> > dir, just tack a .# to the end or somesuch.  The device the LED is tied to
> > already differentiates them.  That would save a lot of chars for something
> > much more useful (the function).
> 
> Ouch, I'm looking into this. I wish I'd known about it earlier. I agree
> function is more important but didn't want to break the existing
> convention. I guess this limitation comes from the kobjects involved...

Richard, any ideas for that?  It *is* still time to change this for 2.6.25,
if required.  If you changed it once already, changing it again won't cause
further damage.

I need to know if the current naming scheme will hold or not, I do NOT want
an ABI issue on thinkpad-acpi, and I know for a fact at least Debian will
want to use the thinkpad-acpi LED interface as soon as I deploy it.  I want
to send the thinkpad-acpi LED interface patches to the users as soon as
possible.

Sincerely?  I think you should make it <function>:[color][.instance] and
drop device name compleley, ASAP.

I will write the patches for mainline and your for-mm branch, if that would
speed up things.  But I need to know what you have decided, first.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
