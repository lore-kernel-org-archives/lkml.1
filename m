Return-Path: <linux-kernel-owner+w=401wt.eu-S1946210AbXBPS7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946210AbXBPS7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946064AbXBPS7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:59:32 -0500
Received: from ns.suse.de ([195.135.220.2]:53179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946036AbXBPS7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:59:32 -0500
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: Could the k8temp driver be interfering with ACPI?
References: <45D5EA88.7090300@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 16 Feb 2007 20:59:33 +0100
In-Reply-To: <45D5EA88.7090300@redhat.com>
Message-ID: <p73odntg9ga.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert <cebbert@redhat.com> writes:
> 
> So, could ACPI and the k8temp driver be at odds?

Yes, there is no locking between ACPI and Linux drivers for register access.
e.g. if there is a indexed register both try to access (and temperature
sensors tend to use these things) they can race and get corrupted data.

-Andi
