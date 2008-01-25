Return-Path: <linux-kernel-owner+w=401wt.eu-S1765220AbYAYIpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765220AbYAYIpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:45:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbYAYIOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:14:50 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:4609
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbYAYIOt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:14:49 -0500
Message-Id: <4799A8A6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 25 Jan 2008 08:15:18 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Keir Fraser" <Keir.Fraser@cl.cam.ac.uk>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Matt Mackall" <mpm@selenic.com>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH UPDATE] x86: ignore spurious faults
References: <47992CB2.8050606@goop.org>
 <C3BF420A.12CFE%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C3BF420A.12CFE%Keir.Fraser@cl.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, another thought: permitting (and handling) spurious faults for
kernel mappings conflicts with NMI handling, i.e. great care would be
needed to ensure the NMI path cannot touch any such mapping. So
even the present Xen/Linux Dom0 implementation may have some
(perhaps unlikely) problems here, and it would get worse if we added
e.g. a virtual watchdog NMI (something I am considering, which would
then extend the problem to DomU-s).

Jan

