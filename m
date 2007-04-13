Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbXDMSUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbXDMSUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 14:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbXDMSUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 14:20:01 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:45727 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119AbXDMSUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 14:20:00 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Date: Fri, 13 Apr 2007 12:18:43 -0600
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
References: <45D5EA88.7090300@redhat.com> <20070302114023.GD2163@elf.ucw.cz> <20070302150313.198b6053.khali@linux-fr.org>
In-Reply-To: <20070302150313.198b6053.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704131218.44045.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 March 2007 07:03, Jean Delvare wrote:
> ... The primary issue is the concurrent access
> to resources, which cause lots of trouble which are hard to investigate.
> If ACPI reserves the ports, then the SMBus or hardware monitoring
> drivers (or any other conflicting driver) will cleanly fail to load,
> which would be a move in the right direction. ...
> 
> So, can ACPI actually reserve the ports it accesses?

Sorry to join this discussion so late.

ACPI tells us the resources used by devices.  Today, we don't reserve
ACPI resources until a driver claims a device.  PCI does some sort of
reservation up front, before the driver claims devices.  Conceptually,
I think ACPI should do the same thing, and I don't think it's that
hard to do.

But breaking things like lmsensors would make the transition painful.

Bjorn
