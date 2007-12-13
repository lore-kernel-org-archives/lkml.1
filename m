Return-Path: <linux-kernel-owner+w=401wt.eu-S1758619AbXLMIYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619AbXLMIYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbXLMIYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:24:41 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:38768 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbXLMIYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:24:40 -0500
Date: Thu, 13 Dec 2007 09:24:37 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Kyungmin Park" <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][MMC] Fix wrong EXT_CSD_REV handling
Message-ID: <20071213092437.7aa2b928@poseidon.drzeus.cx>
In-Reply-To: <9c9fda240712130008s227a77dsbd9333c5227d51eb@mail.gmail.com>
References: <20071213071311.GA2970@party>
	<20071213085332.18d2790d@poseidon.drzeus.cx>
	<9c9fda240712130008s227a77dsbd9333c5227d51eb@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 17:08:16 +0900
"Kyungmin Park" <kmpark@infradead.org> wrote:

> 
> In my MMC Spec. (v4.2), there's no problem to read it even though it's
> revision 1.1
> 

Well, the spec says that those reserved fields "should be zero". Unfortunately, people seem to have read this in the IETF sense and not as "the fields MUST be zero". I.e. I've seen cards where reserved fields contain junk.

> Anyway how do it handle this one? Do you have any idea?
> 

The EXT_CSD is read after the CID, so add some table that maps certain workarounds to specific cards. Then add some bit saying "is really EXT_CSD 1.2" and check for that bit when parsing the EXT_CSD.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
