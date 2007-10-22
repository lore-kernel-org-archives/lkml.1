Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXJVMnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXJVMnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXJVMnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:43:21 -0400
Received: from web52902.mail.re2.yahoo.com ([206.190.49.12]:32661 "HELO
	web52902.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752008AbXJVMnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:43:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xMOg9ZV1NmdPhQJu5zD+62ig0EeY6hza/fQNvt2L5fXTjWLT4HGtWI+58TmRBIWi0VhUTw/GMhfnPliMYy4mJYenJOsjTojSFar/FwH6frXsG8YSaoX3gdWqjcWgu3Zo18hctl2a2o/3IdPSRg+oupjyVyKoPHmC+ZPfHo6Ems4=;
X-YMail-OSG: b45YG8QVM1lkUF5i229fcnMAZzIePelO4W70YIXQ.0iLtEx4Dams7ESzbdFZWVWpLyZKqiLylFPbTags2aVo1ErduamNGiVKSR7g4v0c8cikhY6Qn1w-
Date: Mon, 22 Oct 2007 13:43:16 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [2.6.23.1] PCI device locking up the computer when its module loads
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <511770.44451.qm@web52902.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Netgear MA301 PLX wireless networking adapter which wants to use the hostap_plx driver in
Linux 2.6.23.1. This very same piece of hardware works fine in an old(!) P120 machine running
2.4.33, but makes the 2.6.23.1 kernel freeze as soon as the pci_enable_device() function is called
in prism2_plx_probe. What seems to happen is that IRQ 5 is signalled (the adapter's IRQ, according
to lspci), but the handler function hasn't been installed yet and so the kernel disables IRQ 5 and
locks up. However, the documentation that I have read implies that calling pci_enable_device()
before requesting the IRQ number to install the handler on is "The Right Thing to do", because
otherwise the IRQ number might change.

I have tried booting with "acpi=off nolapic" to no effect. The kernel is UP with 4K stacks and
PREEMPT.

Can anyone suggest what a suitable fix might be, please? Because I am currently thinking "CLI" and
"STI"!

Cheers,
Chris



      ___________________________________________________________ 
Want ideas for reducing your carbon footprint? Visit Yahoo! For Good  http://uk.promotions.yahoo.com/forgood/environment.html
