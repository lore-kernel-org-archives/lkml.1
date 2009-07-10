Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZGJSCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZGJSCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZGJSCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:02:00 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:28967 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751871AbZGJSB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:01:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OX6qemEjEkObDD12L5tvbCPJGnf8kD/fTTgUkRdK/RwxPXgPfn8djt3Fjw9VAM4jHr1UaxnPTMNuaW8zsBQjGQVanL89muites8zICF57SJGr24qO4YWBhnnqTDdSlSPgBT3KU/k7ZEa7DWzVKbEbIdaY6pKIIW2YOv4EktWqwA=  ;
X-YMail-OSG: 04ubyTwVM1kgJv_TAEke9YuDXMj6EI_8NMsXOuE89mCUboksb4Kpoq57FE_8ooSAOymq6972An0lz4irZjAaTISgCXmXW7yKuGlQe0QvMom4pJUu1tBHXW8Q.wI5LJ5dI.NrRzuYiIgd6uf56p_Y2_Sn60BowDscX202TItYP4LHzUown9DYZQzpTyrV6wCvdZRz4N5ID5JQ1Axe7JeAt3mSAo1zwklaI.fFfr85kC1kAuuQdtZHplhdbI3glR5y7cJc.fbjGWMCeCGOANqv6WUt07NHt2eKtalVrsSg_lXxgSCi2Kv3
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "vimal singh" <vimalsingh@ti.com>
Subject: Re: [PATCH 1:2] [MTD][NAND]omap: Adding support for nand prefetch-read  and post-write, in MPU mode.
Date: Fri, 10 Jul 2009 11:01:57 -0700
User-Agent: KMail/1.9.10
Cc: linux-mtd@lists.infradead.org, "Tony Lindgren" <tony@atomide.com>,
       dwmw2@infradead.org, dedekind@infradead.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
References: <61339.192.168.10.89.1247226724.squirrel@dbdmail.itg.ti.com>
In-Reply-To: <61339.192.168.10.89.1247226724.squirrel@dbdmail.itg.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907101101.58029.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 July 2009, vimal singh wrote:
> +static void omap_read_buf8(struct mtd_info *mtd, u_char *buf, int len)
> +{
> +       struct nand_chip *nand = mtd->priv;
> +       u_char *p = (u_char *)buf;
> +
> +       while (len--)
> +               *p++ = __raw_readb(nand->IO_ADDR_R);
> +}

Better as __raw_readsb() yes?  Or maybe ioread8_rep().

... speaking of which, maybe the MTD layer can finally
default to using the accelerated block PIO calls, now
that ioreadX_rep() is supposed to work on all arches...

Last time I measured, that change alone was worth
something like a 10% speedup.  Maybe more.
