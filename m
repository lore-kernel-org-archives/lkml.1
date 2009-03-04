Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZCDAav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZCDAav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 19:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZCDAak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 19:30:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52944 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbZCDAaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 19:30:39 -0500
Date: Wed, 4 Mar 2009 09:29:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       lizf@cn.fujitsu.cn, menage@google.com
Subject: Re: + cgroup-allow-subsys-to-set-default-mode-of-its-own-file.patch
 added to -mm tree
Message-Id: <20090304092920.cf5fda78.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090303075900.GB10019@elte.hu>
References: <200902262100.n1QL0EoR021847@imap1.linux-foundation.org>
	<20090303075900.GB10019@elte.hu>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009 08:59:00 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> 
> > +		int mode = 0644;
> > +		if (cft->mode)
> > +			mode = cft->mode;
> 
> ditto...
> 
Maybe Li Zefan's one "cgroups-show-correct-file-mode.patch" is now in -mm.
and this patch is dropped. And it has the same problem...

Li-san, could you rewrite this part of your patch
==
+	if (cft->read || cft->read_u64 || cft->read_s64 ||
+	    cft->read_map || cft->read_seq_string)
+		mode |= 0444;
+
+	if (cft->write || cft->write_u64 || cft->write_s64 ||
+	    cft->write_string || cft->trigger)
+		mode |= 0200;
+
==
with macro as S_IRUSR etc... ?

Thanks,
-Kame

