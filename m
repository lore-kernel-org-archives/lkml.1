Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYLGMQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYLGMQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 07:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYLGMQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 07:16:06 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4890 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYLGMQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 07:16:05 -0500
Date: Sun, 7 Dec 2008 13:16:01 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: Fw: Re: [2.6.27] filesystem (ext3) corruption (access beyond end)
Message-ID: <20081207121601.GN30807@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Fri Dec  5 18:18:31 CET 2008
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I ran several disk-intensive jobs (git clone, kernel build, apt-get dist-upgrade)
but none of those could trigger any bugs.
BUT, running my http://vanheusden.com/pyk/ script, I definately can trigger the
problem:
[85202.195563] rtc0: alarms up to one month, y3k, hpet irqs
[85204.035802] journal_bmap: journal block not found at offset 2060 on dm-0
[85204.035818] Aborting journal on device dm-0.
[85311.242093] ext3_abort called.
[85311.242120] EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected aborted journal
[85311.242154] Remounting filesystem read-only
[86331.285847] EXT3-fs error (device dm-0): htree_dirblock_to_tree: bad entry in directory #24568: rec_len % 4 != 0 - offset=0, inode=4098364138, rec_len=59542, name_len=76
[89931.353863] EXT3-fs error (device dm-0): htree_dirblock_to_tree: bad entry in directory #24568: rec_len % 4 != 0 - offset=0, inode=4098364138, rec_len=59542, name_len=76

[92499.263276] attempt to access beyond end of device
[92499.263296] dm-2: rw=17, want=4177066240, limit=6004736
[92499.263311] Buffer I/O error on device dm-2, logical block 522133279
[92499.263333] lost page write due to I/O error on dm-2
[92499.263341] Aborting journal on device dm-2.
[92499.263504] ext3_abort called.
[92499.263515] EXT3-fs error (device dm-2): ext3_journal_start_sb: Detected aborted journal
[92499.263543] Remounting filesystem read-only

[93531.419902] EXT3-fs error (device dm-0): htree_dirblock_to_tree: bad entry in directory #24568: rec_len % 4 != 0 - offset=0, inode=4098364138, rec_len=59542, name_len=76

Very odd since the script only rmmod/insmods modules and trying to
rmmod for example ext3-module shouldn';t be a problem since it is
in use.

On Fri, Dec 05, 2008 at 10:46:39AM +0100, Randolf Pohl wrote:
> I think, stable and gregkh should be CCed on this,
> and yes, I guess this deserves some investigation.
> 
> Regards,
> 
> Randolf
> 
> http://lkml.org/lkml/2008/12/4/246
> 
> Folkert van Heusden wrote:
> 
> > Hi,
> > 
> > With 2.6.26 and 2.6.27 a system of mine (a P4 with HT and IDE disk)
> > gets massive disk-corruption: in dmesg warnings for access beyond
> > drive end.
> > Now this bug did not happen in 2.6.18 (debian kernel) and it seems to
> > be gone in 2.6.28-rc* as well.
> > My question now is: should it still be investigated?


Folkert van Heusden

-- 
Multitail est un outil permettant la visualisation de fichiers de
journalisation et/ou le suivi de l'exécution de commandes. Filtrage,
mise en couleur de mot-clé, fusions, visualisation de différences
(diff-view), etc.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
