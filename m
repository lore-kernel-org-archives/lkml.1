Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbYIQOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbYIQOeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbYIQOeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:34:07 -0400
Received: from bu3sch.de ([62.75.166.246]:48935 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbYIQOeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:34:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Wed, 17 Sep 2008 16:33:41 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Adel Gadllah <adel.gadllah@gmail.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Larry Finger <Larry.Finger@lwfinger.net>
References: <48CFC03A.8020708@lwfinger.net> <200809171626.28782.mb@bu3sch.de> <20080917142931.GF5407@tuxdriver.com>
In-Reply-To: <20080917142931.GF5407@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809171633.41397.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 September 2008 16:29:31 John W. Linville wrote:
> On Wed, Sep 17, 2008 at 04:26:28PM +0200, Michael Buesch wrote:
> > On Wednesday 17 September 2008 00:37:29 Henrique de Moraes Holschuh wrote:
> > > On Tue, 16 Sep 2008, Michael Buesch wrote:
> > > > But I don't know how to tell the rfkill subsystem about the states and
> > > 
> > > rfkill_force_state().  Must NOT be called from within atomic contextes,
> > > something I haven't got around to find a proper way of fixing, and nobody
> > > else seems to be on a rfkill coding frenzy right now.
> > 
> > That's a showstopper for us, as we have to change the state from
> > within an interrupt tasklet.
> 
> Workqueue?

Yeah, that's possible to implement yet another workaround using a workqueue.
However it would be nice to have rfkill either support atomic context
or implement the workaround in the rfkill core, as I'm sure there are more
devices that report rfkill changes via interrupt.

-- 
Greetings Michael.
