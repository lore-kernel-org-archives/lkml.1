Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbZKJLJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbZKJLJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZKJLJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:09:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48373 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752714AbZKJLJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:09:04 -0500
Date: Tue, 10 Nov 2009 11:09:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       device@lanana.org, rubini@vision.unipv.it, gregkh@suse.de,
       cluster-devel@redhat.com
Subject: Re: [PATCH] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091110110942.4cb70b13@lxorguk.ukuu.org.uk>
In-Reply-To: <20091109220257.GD12217@vespa.holoscopio.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com>
	<20091109132836.6cf7f559.akpm@linux-foundation.org>
	<20091109220257.GD12217@vespa.holoscopio.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We could consider buggy the caller which asks for the same device name
> more than once, without unregistering the first device. But better safe

If they ask for the same name we certainly should. Probably we should
error that request and use WARN_ON() to shame the offender in
kerneloops.org.

> than sorry: we should protect the correct drivers from the buggy ones
> and avoid a depletion of the minor numbers. And, in case the driver core
> returns another error for another reason (from device_create), we do the
> right thing.

Agreed we need to protect the working drivers.

Alan
