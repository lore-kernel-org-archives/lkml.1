Return-Path: <linux-kernel-owner+w=401wt.eu-S932980AbXBPHUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbXBPHUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 02:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932985AbXBPHUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 02:20:47 -0500
Received: from gw.goop.org ([64.81.55.164]:34465 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932980AbXBPHUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 02:20:45 -0500
Message-ID: <45D55B4E.4000008@goop.org>
Date: Thu, 15 Feb 2007 23:20:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for paravirt_ops
 interface
References: <20070216022449.739760547@goop.org> <20070215225932.11a1b43e.akpm@linux-foundation.org>
In-Reply-To: <20070215225932.11a1b43e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 Feb 2007 18:24:49 -0800 Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> This patch series implements the Linux Xen guest in terms of the
>> paravirt-ops interface.
>>     
>
> The whole patchset exports 67 symbols to modules.  How come?
>
> Are they all needed?

Yep, pretty much.  They're all generally to do with Xen's virtual device
model, and are needed by modular frontend/backed drivers.  This series
only includes the basic block and network frontend devices, but there
are more waiting in the wings.

The breakdown, roughly, is:

    * event channel management
    * pseudophysical <-> machine addresses
    * grant-table management
    * xenbus, which includes
          o which has a filesystem-like namespace
          o the means to monitor changes in objects in the namespace
          o shared resource management
          o suspend/resume



    J
