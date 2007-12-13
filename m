Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXLMQJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXLMQJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757827AbXLMQJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:09:19 -0500
Received: from smtp104.plus.mail.re1.yahoo.com ([69.147.102.67]:26089 "HELO
	smtp104.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756846AbXLMQJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:09:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:Mail-Followup-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=cafqCp4AvOgVxhXrR1PP5k0PMvSNgPSHxMIo4bGefSbmn9mPekw4q9SWCwJs56iUcNmSR4htNfjdSl98lEJXFZIvZNBBWxXR4PpltdX5T4/OYt2yj8brpu71PHMM9Jy8JCn8OPc5USVsMGnidm9V8SqpIv/jXk+VQD4pTsb2+Uc=  ;
X-YMail-OSG: 3PdCG_oVM1lp7S5zSGk8ggaZivf8798ElTwDygX_eEEJYab2p9yyAplnCf.UlCAxM1vMdZACh3H_I9KPPxWxImO2pMZbCIc4Sx.5kCW3XFIBzHhMDA--
Date: Thu, 13 Dec 2007 17:07:44 +0100
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Benjamin Thery <benjamin.thery@bull.net>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.24-rc5-mm1
Message-ID: <20071213160744.GA4509@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
Mail-Followup-To: bbpetkov@yahoo.de,
	Benjamin Thery <benjamin.thery@bull.net>,
	Pierre Peiffer <pierre.peiffer@bull.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <47613F18.6080601@bull.net> <4761494E.1050704@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4761494E.1050704@bull.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 04:01:34PM +0100, Benjamin Thery wrote:
> The problem comes from the new macro UDPX_INC_STATS_BH introduced
> by Herbert, which was a nice addition to increment the correct 
> UDP MIB depending on the socket family, but unfortunately 
> the use of this macro from kernel code (I mean code not compiled 
> as module) requires that IPv6 is also compiled in kernel 
> (CONFIG_IPv6=y) in order to have udp_stats_in6 defined at link 
> time.
> 
> Benjamin
> 
> Pierre Peiffer wrote:
> > Hi,
> > 
> > 	My config does not link any more:
> > 
> > ...
> >   CHK     include/linux/compile.h
> >   UPD     include/linux/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > net/built-in.o: In function `xs_udp_data_ready':
> > /home/peifferp/containers/kernel/linux-2.6.24-rc5-mm1/net/sunrpc/xprtsock.c:842:
> > undefined reference to `udp_stats_in6'
> > /home/peifferp/containers/kernel/linux-2.6.24-rc5-mm1/net/sunrpc/xprtsock.c:846:
> > undefined reference to `udp_stats_in6'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [sub-make] Error 2
> > 
> > After a first look, udp_stats_in6 seems to be defined in ipv6 (file
> > net/ipv6/udp.c) but I have
> > 
> > CONFIG_IPV6=m
> > and
> > CONFIG_SUNRPC=y
> > 
> > So, SUNRPC uses something defined in a module in my case ?
> > 
> > ... looking more, this dependency seems to have been introduced by the patch
> > [UDP]: Restore missing inDatagrams increments
> > ( http://thread.gmane.org/gmane.linux.network/79716/focus=79831 )
> > 
> > (I cc netdev)
> > 
> > I don't know what is the right way to fix this ... ?

you might do "select IPV6" in the SUNRPC section of fs/Kconfig, however select is
evil...

-- 
Regards/Gruﬂ,
    Boris.
