Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbYEFEhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbYEFEhR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYEFEhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:37:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37211 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYEFEhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:37:01 -0400
Date: Tue, 6 May 2008 06:37:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] kconfig: make oldconfig less chatty and clean up conf.c
Message-ID: <20080506043736.GB13366@uranus.ravnborg.org>
References: <20080502204729.GA6534@uranus.ravnborg.org> <20080504185737.GA23063@uranus.ravnborg.org> <20080504185950.GC23063@uranus.ravnborg.org> <Pine.LNX.4.64.0805060455590.30555@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805060455590.30555@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 05:08:40AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Sun, 4 May 2008, Sam Ravnborg wrote:
> 
> > We now check for valid stadin in both cases and this
> > may break a script here and there.
> 
> I strongly disagree with this, please preserve the old behaviour. It took 
> a while to work out the current behaviour.
> Only silentoldconfig checks for stdin because it's used as hook during 
> kbuild to verify the config. For all other interactive targets the user 
> has to know what he's doing, e.g. it's valid to do "yes '' | make 
> oldconfig".
I will test a bit more and may revert to the old behaviour.
One good thing with the new behaviour is that
make oldconfig > /dev/null
does not hang if there is new symbols - and I would like to keep
it so.

> 
> > -		switch (input_mode) {
> > -		case set_no:	 name = "allno.config"; break;
> > -		case set_mod:	 name = "allmod.config"; break;
> > -		case set_yes:	 name = "allyes.config"; break;
> > -		case set_random: name = "allrandom.config"; break;
> > -		default: break;
> > -		}
> > -		if (!stat(name, &tmpstat))
> > -			conf_read_simple(name, S_DEF_USER);
> > -		else if (!stat("all.config", &tmpstat))
> > -			conf_read_simple("all.config", S_DEF_USER);
> > -		break;
> > -	default:
> > -		break;
> >  	}
> 
> This isn't yet in aconf.c.
On purpose. It is very very seldom used and with K=file
it is now much easier to specify a base configuration.
So no need for all the special filenames.

	Sam
