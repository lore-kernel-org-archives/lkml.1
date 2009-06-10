Return-Path: <linux-kernel-owner+w=401wt.eu-S1759578AbZFJMpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759578AbZFJMpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755999AbZFJMpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:45:45 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:35053 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbZFJMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:45:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=eo+CBr3DcHLrcx5OkV8CswXP2x+jTTFxDURx+iVi9pm9jEb0S9aSQTlt/TJl6xEDQ5
         OrXn505zs3yRxUfAJA+eEfXM66X2LLQdDen08SE7i+QdMdAZibehaAwWDG9Jt0/g2Lpt
         UgBqWDJRNt+wyEhhWLU5bPL4XvcRWmaqqQj5M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH next] ide: fix PowerMac bootup oops
Date: Wed, 10 Jun 2009 14:50:07 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090609-07907-g3d51e1b-dirty; KDE/4.2.3; i686; ; )
Cc: Joao Ramos <joao.ramos@inov.pt>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <Pine.LNX.4.64.0906082137120.22183@sister.anvils> <200906091436.19710.bzolnier@gmail.com> <Pine.LNX.4.64.0906091357490.21803@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0906091357490.21803@sister.anvils>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906101450.08632.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009 15:02:20 Hugh Dickins wrote:
> On Tue, 9 Jun 2009, Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 09 June 2009 13:44:25 Hugh Dickins wrote:
> > > 
> > > But memset id in probe_for_drive() when it might be being reused -
> > > or would it be better to memset it wherever it used to be kfreed?
> > 
> > Please memset() it in ide_port_init_devices_data() -- this function
> > is called before IDE device structure is going to be (re-)used.
> 
> That makes sense too, thanks, here we go...
> 
> 
> [PATCH next] ide: fix PowerMac bootup oops
> 
> PowerMac bootup with CONFIG_IDE=y oopses in ide_pio_cycle_time():
> because "ide: try to use PIO Mode 0 during probe if possible" causes
> pmac_ide_set_pio_mode() to be called before drive->id has been set.
> 
> Bart points out other places which now need drive->id set earlier,
> so follow his advice to allocate it in ide_port_alloc_devices()
> (using kzalloc_node, without error message, as when allocating drive)
> and memset it for reuse in ide_port_init_devices_data().
> 
> Fixed in passing: ide_host_alloc() was missing ide_port_free_devices()
> from an error path.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

applied
