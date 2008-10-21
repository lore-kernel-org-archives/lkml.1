Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYJUPu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYJUPu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYJUPuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:50:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56471 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751704AbYJUPuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:50:19 -0400
Date: Tue, 21 Oct 2008 16:50:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Tomaso.Paoletti@caviumnetworks.com
Subject: Re: [PATCH] serial: Initialize spinlocks in 8250 and don't clobber
 them.
Message-ID: <20081021165018.28794974@lxorguk.ukuu.org.uk>
In-Reply-To: <48FDF6CB.4070605@caviumnetworks.com>
References: <48F51114.2010105@caviumnetworks.com>
	<20081020141750.d0610586.akpm@linux-foundation.org>
	<20081021103833.5e960c8d@lxorguk.ukuu.org.uk>
	<48FDF6CB.4070605@caviumnetworks.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The question is:  What is the best way to initialize some (or all) fields of a structure *except* a single lock field that was previously initialized?

Move the initialisation - or at least memset to zero then spin_lock_init
and fill in the other fields later.
