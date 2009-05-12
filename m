Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZELPaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZELPaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZELP3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:29:52 -0400
Received: from pf.FreeDaemonHosting.com ([66.210.104.252]:30339 "EHLO
	FreeDaemonHosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136AbZELP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:29:50 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 May 2009 11:29:50 EDT
X-DSPAM-Result: Innocent
X-DSPAM-Confidence: 0.6000
X-DSPAM-Improbability: 1 in 151 chance of being spam
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 2114,4a09946752506774120641
Date: Tue, 12 May 2009 10:22:10 -0500
From: "Todd T. Fries" <todd@fries.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Clemens Ladisch <clemens@ladisch.de>, David Fries <david@fries.net>,
       David Griffith <dgriffi@cs.csubak.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: bad endpoint address, MOTU FastLane
Message-ID: <20090512152153.GA16714@fries.net>
Reply-To: todd@fries.net
References: <4A092B5C.603@ladisch.de> <Pine.LNX.4.44L0.0905121000020.2799-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0905121000020.2799-100000@iolanthe.rowland.org>
X-Operating-System: OpenBSD g4.fries.net 4.5 GENERIC
X-PGP-Fingerprint: B6 3B 70 46 BC 0F 8C DD  14 D4 C7 D1 47 F6 23 FA
X-HOMEPAGE: http://todd.fries.net
X-COMPANY: http://FreeDaemonConsulting.com
X-tra-email: todd@{fries.net,OpenBSD.org} toddfries@gmail.com
X-IM: toddfries:AIM 115268457:ICQ todd@fries.net:MSN
X-Jabber: toddfries@gmail.com todd@fries.net todd@freedaemon.com
User-Agent: Mutt/1.5.18 (2008-05-17)
X-FDH-MailScanner-Information: http://FreeDaemonHosting.com/MailScanner.html
X-MailScanner-ID: n4CFMqnF006963
X-FDH-MailScanner: clean
X-FDH-MailScanner-From: todd@fries.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm actually the owner of said device, and have actually purchased
something that is complaint.  However, not all owners of said device
are as able or willing.

The point in my opinion is that it used to work and now after an upgrade
(to support a pchdtv.com tuner) the MOTU doesn't, only the software has
changed.  Thanks for giving me one more reason to avoid Linux.

IMHO the principal of 'be generous in what you accept, strict in what you give..'
for specs applies here..

Worst case, quirk entry, eh?

Penned by Alan Stern on 20090512 10:08.01, we have:
| On Tue, 12 May 2009, Clemens Ladisch wrote:
| 
| > David Fries wrote:
| > > usb_submit_urb returns -22 EINVAL invalid argument as it is trying to
| > > submit an interrupt packet to what is registered as an isoc endpoint.
| 
| How does one know which type the endpoint really is?  Through prior 
| experience with the device?
| 
| > > The second interface has the same end point addresses as the first.
| > > Any suggestions on how to deal with this class of broken hardware?
| > > 
| > > I:* If#= 0 Alt= 0 ...
| > > E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=1ms
| > > I:* If#= 1 Alt= 0 ...
| > > E:  Ad=81(I) Atr=01(Isoc) MxPS=   4 Ivl=1ms
| > 
| > AFAICS the USB core memorizes the descriptor belonging to a specific
| > endpoint number whenever usb_set_interface() is called.  In this case,
| > the second interface is initialized later, so the second set of
| > descriptors wins.
| > 
| > The driver could call usb_set_interface() again for the first interface
| > so that the USB core takes notice of the first set of endpoints again.
| > Please try the patch below.
| > 
| > I guess I'll have to write another quirk for this.
| > 
| > 
| > --- linux/sound/usb/usbmidi.c
| > +++ linux/sound/usb/usbmidi.c
| > @@ -1779,6 +1779,7 @@
| >  		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
| >  		break;
| >  	case QUIRK_MIDI_RAW:
| > +		usb_set_interface(umidi->chip->dev, 0, 0);
| >  		umidi->usb_protocol_ops = &snd_usbmidi_raw_ops;
| >  		err = snd_usbmidi_detect_per_port_endpoints(umidi, endpoints);
| >  		break;
| 
| This is only a bandaid.  The underlying problem is still there.  
| Basically, the second interface shouldn't exist at all.  The only
| proper way to deal with it is to pretend there's only one interface --
| which would mean changing the descriptors before the kernel parses
| them.
| 
| A much easier approach is to throw the device away and replace it with 
| something that _is_ compliant with the USB specification.
| 
| Alan Stern

-- 
Todd Fries .. todd@fries.net

 _____________________________________________
|                                             \  1.636.410.0632 (voice)
| Free Daemon Consulting, LLC                 \  1.405.227.9094 (voice)
| http://FreeDaemonConsulting.com             \  1.866.792.3418 (FAX)
| "..in support of free software solutions."  \          250797 (FWD)
|                                             \
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                                                 
              37E7 D3EB 74D0 8D66 A68D  B866 0326 204E 3F42 004A
                        http://todd.fries.net/pgp.txt

