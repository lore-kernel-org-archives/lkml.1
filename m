Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXLTAqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXLTAqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 19:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXLTAp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 19:45:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54218 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752548AbXLTAp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 19:45:59 -0500
Date: Wed, 19 Dec 2007 16:45:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: peerchen@gmail.com, linux-kernel@vger.kernel.org, acurrid@nvidia.com,
       pchen@nvidia.com, ebiederm@xmission.com
Subject: Re: [PATCH] msi: set 'En' bit of MSI Mapping Capability
Message-Id: <20071219164555.1916fa42.akpm@linux-foundation.org>
In-Reply-To: <20071219164125.a3eac8ba.akpm@linux-foundation.org>
References: <200712182300373901202@gmail.com>
	<20071219164125.a3eac8ba.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 16:41:25 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> It would be better to just add a stub implementation of
> ht_enable_msi_mapping() for all the other architectures - avoid fancy cpp
> tricks.


And by this I really do mean going into each include/asm-*/pci.h and adding


struct pci_dev;		(if needed)
...

static inline void ht_enable_msi_mapping(struct pci_dev *dev)
{
}


no macros, no ifdef tricks, no include tricks.  Just straight, clean, fully
typechecked C.

