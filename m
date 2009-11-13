Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZKMKdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZKMKdD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZKMKc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:32:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:49457 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbZKMKc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:32:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=WBQVR6T5fXa07lE+Xvq3Uh6Ehz+7LT9zCwxS9ffQ9phc3sTD1gg0BRt+E8XZwCF5sD
         +0NCOmdJkvAgCJBsuVPBbpWLFiE4JJhpmyd5Rmixr4BCrqQhM03D+WmpKoMUEmnksQGC
         qXUR3bqJoctPpIwFXmx0MYQT28RFn2DSaR0fw=
Message-ID: <4AFD35DB.6050604@gmail.com>
Date: Fri, 13 Nov 2009 11:32:59 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.6pre) Gecko/20091108 SUSE/3.0b4-11.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: chris.mason@oracle.com
CC: zheng.yan@oracle.com, linux-btrfs@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: BTRFS: unreachable code found
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stanse found unreachable code in btrfs_insert_some_items below (don't
look at the line numbers, they are on preprocessed code). I would fix
that if I knew how.

Should the assignment be after the if, before the break or nowhere?

 3068|int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 3069|       struct btrfs_root *root,
 3070|       struct btrfs_path *path,
 3071|       struct btrfs_key *cpu_key, u32 *data_size,
 3072|       int nr)
 3073|{
...
 3086| for (i = 0; i < nr; i++) {
 3087|  if (total_size + data_size[i] + sizeof(struct btrfs_item) >
 3088|      (((root->leafsize) - sizeof(struct btrfs_header)))) {
 3089|   break;
 3090|   nr = i;
     |This node is unreachable prev next
 3091|  }
 3092|  total_data += data_size[i];
 3093|  total_size += data_size[i] + sizeof(struct btrfs_item);
 3094| }

regards,
-- 
js
Faculty of Informatics, Masaryk University
Suse Labs, Novell
