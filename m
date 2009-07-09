Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbZGIMtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbZGIMtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760336AbZGIMtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:49:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59933 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760004AbZGIMtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:49:13 -0400
Date: Thu, 9 Jul 2009 14:49:09 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: peter meng <mengsanshui@yahoo.com.cn>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Ask a question related Assemble and C revert  within vmlinux ?
Message-ID: <20090709124909.GB3507@jolsa.lab.eng.brq.redhat.com>
References: <789976.67811.qm@web15703.mail.cnb.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <789976.67811.qm@web15703.mail.cnb.yahoo.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 06:50:47PM +0800, peter meng wrote:
> 
> Hi
> 
> I compile the linux kernel with mips .
> Is there any tools let the Assemble code correspond to C code ?
> I mean Assemble line correspond to C line .

not sure about mips, but for x86:
objdump -S ./ex.o

you need to have debug info compiled in..

jirka

> 
> 
> 
> ----------------cut from objdump -S vmlinux ----------------------
> 801b5b40 <ip_rcv>:
> 801b5b40:       27bdffc0        addiu   sp,sp,-64
> 801b5b44:       afb00028        sw      s0,40(sp)
> 801b5b48:       afbf0038        sw      ra,56(sp)
> 801b5b4c:       afb30034        sw      s3,52(sp)
> 801b5b50:       afb20030        sw      s2,48(sp)
> 801b5b54:       afb1002c        sw      s1,44(sp)
> 801b5b58:       8c82006c        lw      v0,108(a0)
> 801b5b5c:       3c0300e0        lui     v1,0xe0
> 801b5b60:       3c050060        lui     a1,0x60
> 801b5b64:       00431024        and     v0,v0,v1
> 801b5b68:       10450022        beq     v0,a1,801b5bf4 <ip_rcv+0xb4>
> 801b5b6c:       00808021        move    s0,a0
> 801b5b70:       3c128029        lui     s2,0x8029
> 801b5b74:       8e42ef90        lw      v0,-4208(s2)
> 801b5b78:       00808821        move    s1,a0
> 801b5b7c:       8c430004        lw      v1,4(v0)
> 801b5b80:       24630001        addiu   v1,v1,1
> 801b5b84:       ac430004        sw      v1,4(v0)
> 801b5b88:       8c850078        lw      a1,120(a0)
> 801b5b8c:       38a50001        xori    a1,a1,0x1
> 801b5b90:       14a00027        bnez    a1,801b5c30 <ip_rcv+0xf0>
> 801b5b94:       00000000        nop
> 801b5b98:       122000d6        beqz    s1,801b5ef4 <ip_rcv+0x3b4>
> 801b5b9c:       02208021        move    s0,s1
> 801b5ba0:       8e250058        lw      a1,88(s1)
> ........
> ----------------------ip_rcv source code ---------------
> 
> int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_type *pt, struct net_device *orig_dev)
> {
> 	struct iphdr *iph;
> 	u32 len;
> 
> 	/* When the interface is in promisc. mode, drop all the crap
> 	 * that it receives, do not try to analyse it.
> 	 */
> 	if (skb->pkt_type == PACKET_OTHERHOST)
> 		goto drop;
> 
> 	IP_INC_STATS_BH(IPSTATS_MIB_INRECEIVES);
> 
> 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
> 		IP_INC_STATS_BH(IPSTATS_MIB_INDISCARDS);
> 		goto out;
> 	}
> 
> 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> 		goto inhdr_error;
> 
> 	iph = skb->nh.iph;
> 
> 
> 	if (iph->ihl < 5 || iph->version != 4)
> 		goto inhdr_error;
> 
> 	if (!pskb_may_pull(skb, iph->ihl*4))
> 		goto inhdr_error;
> 
> 	iph = skb->nh.iph;
> .............
> 
> 
> Thanks a lot .
> Best Regards.
> Peter Meng
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
