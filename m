Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbXJAUMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbXJAUMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbXJAUMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:12:24 -0400
Received: from 8bytes.org ([88.198.83.132]:60878 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753629AbXJAUMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:12:24 -0400
Date: Mon, 1 Oct 2007 22:12:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [19/50] Experimental: detect if SVM is disabled by BIOS
Message-ID: <20071001201222.GB1404@8bytes.org>
References: <200709221231.836138000@suse.de> <20070921223218.22A8D13DCD@wotan.suse.de> <20070922091708.GD8998@8bytes.org> <200710011847.50533.andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710011847.50533.andi@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 06:47:50PM +0200, Andi Kleen wrote:
> On Saturday 22 September 2007 11:17:08 Joerg Roedel wrote:
> > I don't think we need this patch. When SVM is disabled KVM will tell on
> > module load. 
> 
> The point is that people often want to know in advance (before they
> even try to use KVM or Xen) if their CPU and BIOS supports this.

If the CPU supports SVM this is visible to the user because the SVM
feature flag does not disappear when its disabled. But because with CPUs
having the SVM-lock feature it can be re-enabled in a secure way under
some circumstances the information in /proc/cpuinfo will not be
reliable. Maybe we can check for it in identify_cpu() and print to the
kernel log if its disabled? It will be visible to the user through
dmesg.

Joerg
