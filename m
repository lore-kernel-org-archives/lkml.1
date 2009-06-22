Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZFVSm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZFVSm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZFVSmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:42:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44950 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbZFVSmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:42:17 -0400
Date: Mon, 22 Jun 2009 21:41:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
	notifier race conditions
Message-ID: <20090622184139.GG15228@redhat.com>
References: <alpine.DEB.1.10.0906201508460.25534@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906201640380.25534@makko.or.mcafeemobile.com> <4A3D895C.7020605@novell.com> <alpine.DEB.1.10.0906210946560.18205@makko.or.mcafeemobile.com> <4A3E7E63.1070407@novell.com> <alpine.DEB.1.10.0906211613200.8816@makko.or.mcafeemobile.com> <4A3FABD9.7080108@novell.com> <alpine.DEB.1.10.0906220952090.10952@makko.or.mcafeemobile.com> <4A3FC2B1.4050107@novell.com> <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906221055480.10952@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 11:03:22AM -0700, Davide Libenzi wrote:
> In your case of kernel-to-kernel scenario, why would you need eventfd at 
> all, if userspace role in that model is simply to create it?

That's not 100% true. We have a mode where userspace is the producer
and/or consumer (migration mode) and we switch between that and
direct kernel-to-kernel communication.

