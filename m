Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZCASpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZCASpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 13:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZCASpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 13:45:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46282 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbZCASpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 13:45:20 -0500
Message-ID: <49AAD7A6.5050106@redhat.com>
Date: Sun, 01 Mar 2009 13:44:54 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com> <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
In-Reply-To: <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the kernel that now boots (when max_pfn is set to = last e820 address regardless of type), efi_enter_virtual_mode() does not call efi_ioremap(). Maybe efi_ioremap() is what needs fixing? I should mention this is a regression. 2.6.26 worked, 2.6.27 does not, and seems like things stopped working in 2.6.26-git1. I will check to see if efi_ioremap() used to be called with a 2.6.26 kernel on this hardware and see where the mapped addresses were. Maybe I can verify efi_ioremap() is actually broken.

Brian


