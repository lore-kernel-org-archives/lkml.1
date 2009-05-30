Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbZE3Qrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbZE3Qrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 12:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZE3Qrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 12:47:33 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48814 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZE3Qrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 12:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rmsbOYZK+pdJwkPJ46a6fY7n7IcoTQQjsfz9c9VDz2ZZAebS681ZFcbIENgJHeGDH5
         XIDhIF/eY8zlWLnHwfXZBsxtZwLXAH8+AULCFdlm1rVHlncJIDsugLUSLc4Zmwy1ddLA
         321U/YoiMOGYNcjJxImRnzpkvwNiujz5WPf58=
From: Diego Calleja <diegocg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Performance regressions in 2.6.30-rc7?
Date: Sat, 30 May 2009 18:51:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-00187-gb4348f3; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200905282249.28592.diegocg@gmail.com> <20090529210718.bef7a9c1.akpm@linux-foundation.org>
In-Reply-To: <20090529210718.bef7a9c1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905301851.47708.diegocg@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sábado 30 Mayo 2009 06:07:18 Andrew Morton escribió:
> Those regressions are huge.  They appear to be on compute-intensive
> workloads too.
> 
> I wonder if some expensive debugging option turned itself on or
> something silly like that.

They use the vanilla kernels that ubuntu ship with their own configs,
so they shouldn't be using any expensive debugging option.

I've run myself two of those tests (I've not tested gnupg as I'm
allergic to it). I can't reproduce any regression with 7zip, I'm however
able to reproduce the regression in tiobench write latency, using 32
threads and 64 MB block size (--threads 32 --block 65536). I used ext4
(phoronix uses ext3).


Random Writes
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.29                        2000  65536  32   24.16 107.2%     0.051        0.21   0.00000  0.00000    23

Random Writes
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.30-rc7-00149-g3218911     2000  65536  32   23.06 178.4%     0.711      164.72   0.00000  0.00000    13

