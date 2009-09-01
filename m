Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZIAPGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZIAPGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZIAPGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:06:33 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:54806 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753837AbZIAPGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:06:30 -0400
Date: Tue, 1 Sep 2009 14:42:29 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Roland Dreier <rdreier@cisco.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Rik van Riel <riel@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
In-Reply-To: <adavdk3q3nk.fsf@cisco.com>
Message-ID: <alpine.DEB.1.10.0909011440210.12112@V090114053VZO-1>
References: <1251282598.3514.20.camel@raz> <alpine.DEB.1.10.0908260943090.9924@gentwo.org> <1251297910.1791.22.camel@maxim-laptop> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org>
 <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain> <4A97071F.5070804@novell.com> <4A973DAE.4020508@redhat.com> <4A975025.8030500@novell.com> <4A975CC4.1090208@novell.com> <alpine.LFD.2.00.0908281218560.2888@localhost.localdomain>
 <alpine.DEB.1.10.0908281446520.7317@gentwo.org> <alpine.LFD.2.00.0908282100040.19335@localhost.localdomain> <alpine.DEB.1.10.0908281551450.17784@gentwo.org> <alpine.LFD.2.00.0908282158100.19335@localhost.localdomain> <alpine.DEB.1.10.0908281619520.15573@gentwo.org>
 <alpine.LFD.2.00.0908282231260.19335@localhost.localdomain> <alpine.DEB.1.10.0908311517410.26046@V090114053VZO-1> <adavdk3q3nk.fsf@cisco.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009, Roland Dreier wrote:

>
>  > Some devices now have per cpu threads. See f.e. Mellanox IB drivers. Maybe
>  > there is a way to restrict that.
>
> AFAIK the Mellanox drivers just create a single-threaded workqueue.

Ok then these per cpu irqs are there to support something different? There
are per cpu irqs here. Seems to be hardware supported?

  62:      13824          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-0
  63:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-1
  64:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-2
  65:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-3
  66:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-4
  67:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-5
  68:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-6
  69:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-7
  70:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-8
  71:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-9
  72:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-10
  73:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-11
  74:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-12
  75:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-13
  76:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-14
  77:          0          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-comp-15
  78:       3225          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      mlx4-async
  79:       1832          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      eth0-0
  80:       5546          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      eth0-1
  81:       2604          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      eth0-2
  82:        124          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      eth0-3
  83:     743126          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      eth0-4
  84:        857          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      eth0-5
  85:        321          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      eth0-6
  86:       2296          0          0          0          0          0
0          0          0          0          0          0          0
0          0          0  IR-PCI-MSI-edge      eth0-7

