Return-Path: <linux-kernel-owner+w=401wt.eu-S1761984AbYENQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761984AbYENQH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYENQHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:07:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54164 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYENQHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:07:12 -0400
Date: Wed, 14 May 2008 09:07:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, davem@davemloft.net,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.26-rc2-mm1 - kernel panic at inet_create() on powerpc
Message-ID: <20080514160705.GB8812@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080514010129.4f672378.akpm@linux-foundation.org> <482B066F.4010605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482B066F.4010605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 09:04:07PM +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> 2.6.26-rc2-mm1 kernel panics on powerpc, while running ltp test over it.
> I have attached the gdb output of the pc and lr registers. The patch
> list_for_each_rcu-must-die-networking.patch points to changes made 
> to the same lines listed by the gdb output.

Hmmm....  Does the panic go away when this patch is reverted?

						Thanx, Paul

>  Unable to handle kernel paging request for data at address 0x00000000
> Faulting instruction address: 0xc000000000481fa0
> cpu 0x0: Vector: 300 (Data Access) at [c0000000eae37900]
>     pc: c000000000481fa0: .inet_create+0xb4/0x330
>     lr: c000000000413340: .__sock_create+0x190/0x280
>     sp: c0000000eae37b80
>    msr: 8000000000009032
>    dar: 0
>  dsisr: 40010000
>   current = 0xc0000000cd201500
>   paca    = 0xc0000000007c3480
>     pid   = 6462, comm = socket01
> enter ? for help
> [c0000000eae37c30] c000000000413340 .__sock_create+0x190/0x280
> [c0000000eae37cf0] c0000000004137e0 .sys_socket+0x40/0x98
> [c0000000eae37d90] c000000000438e18 .compat_sys_socketcall+0xc0/0x234
> [c0000000eae37e30] c0000000000086b4 syscall_exit+0x0/0x40
> --- Exception: c01 (System Call) at 000000000ff20484
> SP (ffc8f770) is in userspace
> 
> 
> 0xc000000000481fa0 is in inet_create (net/ipv4/af_inet.c:290).
> 285             /* Look for the requested type/protocol pair. */
> 286             answer = NULL;
> 287     lookup_protocol:
> 288             err = -ESOCKTNOSUPPORT;
> 289             rcu_read_lock();
> 290             list_for_each_entry_rcu(answer, &inetsw[sock->type], list) {
> 291
> 292                     /* Check the non-wild match. */
> 293                     if (protocol == answer->protocol) {
> 294                             if (protocol != IPPROTO_IP)
> 
> 
> 0xc000000000413340 is in __sock_create (net/socket.c:1171).
> 1166                    goto out_release;
> 1167
> 1168            /* Now protected by module ref count */
> 1169            rcu_read_unlock();
> 1170
> 1171            err = pf->create(net, sock, protocol);
> 1172            if (err < 0)
> 1173                    goto out_module_put;
> 1174
> 1175            /*
> 
> -- 
> Thanks & Regards,
> Kamalesh Babulal,
> Linux Technology Center,
> IBM, ISTL.
