Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbZF2JGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbZF2JGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZF2JGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:06:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbZF2JG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:06:29 -0400
Date: Mon, 29 Jun 2009 11:06:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
In-Reply-To: <20090628140452.GA15816@gallifrey>
Message-ID: <alpine.LNX.2.00.0906291103140.18021@wotan.suse.de>
References: <20090613230842.GA18347@gallifrey> <alpine.LNX.2.00.0906231038500.7457@wotan.suse.de> <20090623185814.GB24108@gallifrey> <200906231106.37460.dmitry.torokhov@gmail.com> <20090628140452.GA15816@gallifrey>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009, Dr. David Alan Gilbert wrote:

> Apologies for the delay; attached is the dmesg from the Debian 2.6.18
> in which keyboard works as previously described.

So the main difference is here:

	drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
	drivers/input/serio/i8042.c: 65 <- i8042 (return) [3]
	drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
	drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [3]
	drivers/input/serio/i8042.c: Interrupt 1, without any data [3]

compared to

	drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
	drivers/input/serio/i8042.c: 65 <- i8042 (return) [1]
	drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
	drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [2]
	drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]

So it looks like it is really affected by the polling timer removal/early 
IRQ registration.

-- 
Jiri Kosina
SUSE Labs
