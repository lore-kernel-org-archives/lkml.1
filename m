Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbYGXL6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbYGXL6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbYGXL6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:58:36 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:32076 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbYGXL6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:58:36 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=FNcYbzlqMx2/JN0tKCZFUotG7MXiDxwCYxJt6lOUSK1jZRSZGHy/teju
   4cDSglm+8SHKucZ1wL8BK6eJP2HKtUTRx3Lou6bzu65BPKIvWTH7VoQOu
   RHs0RyEOpg5IjXh;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="scan'208";a="21057288"
X-IronPort-AV: E=Sophos;i="4.31,245,1215381600"; 
   d="scan'208";a="36308935"
Message-ID: <48886E6D.1030005@fujitsu-siemens.com>
Date: Thu, 24 Jul 2008 13:58:37 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Wichert, Gerhard" <Gerhard.Wichert@fujitsu-siemens.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] x86 (64): make calibrate_APIC_clock() smp-safe
References: <48885DDC.9010003@fujitsu-siemens.com> <20080724111631.GA3432@lenovo>
In-Reply-To: <20080724111631.GA3432@lenovo>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:

> Hi, but what if SMI flood happens? We could stuck here forever, don't we?
> 
>                 - Cyrill -


Yes, if the SMI flood never ends. But you wouldn't want to work on such 
a system anyway (with the current kernel code, your APIC timer would 
most probably be miscalibrated, which can have the weirdest effects).

Anyway, we can add a maximum iteration count to the patch so that there 
is no risk of getting stuck.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20209
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
