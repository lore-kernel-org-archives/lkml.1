Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbXLHUce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbXLHUce (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbXLHUc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:32:27 -0500
Received: from thunk.org ([69.25.196.29]:48469 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbXLHUc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:32:26 -0500
Date: Sat, 8 Dec 2007 15:31:21 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Matt Mackall <mpm@selenic.com>, Mike McGrath <mmcgrath@redhat.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       hmh@debian.org
Subject: Re: entropy gathering (was Re: Why does reading from /dev/urandom
	deplete entropy so much?)
Message-ID: <20071208203121.GP17037@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Garzik <jeff@garzik.org>, Matt Mackall <mpm@selenic.com>,
	Mike McGrath <mmcgrath@redhat.com>,
	Jon Masters <jonathan@jonmasters.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
	Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org, hmh@debian.org
References: <4756B50B.3060100@redhat.com> <20071205144934.GL7259@thunk.org> <1197099477.20786.149.camel@perihelion> <20071208173204.GI17037@thunk.org> <475AD585.7020908@redhat.com> <20071208174908.GJ17037@thunk.org> <20071208181525.GL19691@waste.org> <475AF241.5000809@garzik.org> <20071208195342.GO19691@waste.org> <475AF8D0.1090407@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AF8D0.1090407@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 03:04:32PM -0500, Jeff Garzik wrote:
> That's a bit of a tangent on a tangent.  :)  Most people don't have a 
> hardware RNG.

Actually, most Business class laptops from IBM/Lenovo, HP, Dell,
Fujitsu, and Sony laptops *do* have TPM chips that among other things,
contain a slow but (supposedly, if the TPM microprocessors are to be
believed) secure hardware random number generator for use as a session
key generator.  This is thanks to various US legal mandates, such as
HIPPA for the medical industry, and not just the paranoid ravings of
the MPAA and RIAA.  :-)

The problem is enabling the TPM isn't trivial, and life gets harder if
you want the TPM chip to simultaneously work on dual-boot machines for
both Windows and Linux, but it is certainly doable.

>> I think we should re-evaluate having an internal path from the hwrngs
>> to /dev/[u]random, which will reduce the need for userspace config
>> that can go wrong.

I think the userspace config problems were mainly due to the fact that
there wasn't a single official userspace utility package for the
random number package.  Comments in drivers/char/random.c for how to
set up /etc/init.d/random is Just Not Enough.

If we had a single, official random number generator package that
contained the configuration, init.d script, as well as the daemon that
can do all sorts of different things that you really, Really, REALLY
want to do in userspace, including:

  * FIPS testing (as Jeff suggested --- making sure what you think is 
    randomness isn't 60Hz hum is a Really Good Idea :-)
  * access to TPM (if available --- I have a vague memory that you may
    need access to the TPM key to access any of its functions, and the
    the TPM key is stored in the filesystem)

So....  anyone interested in belling the metaphorical cat?   :-)

	       		     	     	 	      - Ted
