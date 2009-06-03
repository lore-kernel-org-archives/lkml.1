Return-Path: <linux-kernel-owner+w=401wt.eu-S1758775AbZFCR3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775AbZFCR3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZFCR3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:29:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54863 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753376AbZFCR3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:29:24 -0400
Date: Wed, 3 Jun 2009 18:29:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Larry H." <research@subreption.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
Message-ID: <20090603182949.5328d411@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0906031047390.15621@gentwo.org>
References: <20090530192829.GK6535@oblivion.subreption.com>
	<alpine.LFD.2.01.0905301528540.3435@localhost.localdomain>
	<20090530230022.GO6535@oblivion.subreption.com>
	<alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>
	<20090531022158.GA9033@oblivion.subreption.com>
	<alpine.DEB.1.10.0906021130410.23962@gentwo.org>
	<20090602203405.GC6701@oblivion.subreption.com>
	<alpine.DEB.1.10.0906031047390.15621@gentwo.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok. So what we need to do is stop this toying around with remapping of
> page 0. The following patch contains a fix and a test program that
> demonstrates the issue.

NAK - you've now broken half a dozen apps.

One way you could approach this would be to write a security module for
non SELINUX users - one that did one thing alone - decide whether the app
being run was permitted to map the low 64K perhaps by checking the
security label on the file.

Alan
