Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbZKRWwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbZKRWwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZKRWwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:52:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60594 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbZKRWwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:52:38 -0500
Message-ID: <4B047A81.3060104@zytor.com>
Date: Wed, 18 Nov 2009 14:51:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
       roland@redhat.com, rth@redhat.com, mhiramat@redhat.com
Subject: Re: [RFC PATCH 0/6] jump label v3
References: <cover.1258580048.git.jbaron@redhat.com>
In-Reply-To: <cover.1258580048.git.jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2009 02:43 PM, Jason Baron wrote:
> 
> I'm using an atomic 5 byte no-op for x86_64 and a long jump for 32-bit x86.
> My understanding is that not all 32-bit processors have an atomic 5 byte no-op,
> and thus using a long jump or jump 0, for the off case is the safest.
> 

67 66 8D 74 00 (lea si,[si+0]) should work as a 32-bit atomic NOP.  It's
not necessarily the fastest, though (I have no data on that.)
Similarly, 66 66 66 66 90 should also work.

	-hpa
