Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYBFU1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYBFU1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 15:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbYBFU1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 15:27:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbYBFU1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 15:27:00 -0500
Message-ID: <47AA16CA.6000003@zytor.com>
Date: Wed, 06 Feb 2008 12:21:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Neil Horman <nhorman@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       tglx@linutronix.de, mingo@redhat.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH], issue EOI to APIC prior to calling crash_kexec in die_nmi
 path
References: <20080206192555.GA24910@hmsendeavour.rdu.redhat.com> <20080206194040.GA11886@redhat.com> <20080206201223.GA25183@hmsendeavour.rdu.redhat.com>
In-Reply-To: <20080206201223.GA25183@hmsendeavour.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> Can an APIC accept an NMI while already handling an NMI?  I didn't think they
> would interrupt one another, but rather, pend until such time as the previous
> NMI was cleared

The CPU certainly won't (there is a hidden flag that's cleared on IRET 
which disables NMI; it's possible to re-enable NMI by executing a dummy 
IRET inside the NMI handler.)

	-hpa
