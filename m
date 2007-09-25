Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbXIYEMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbXIYEMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbXIYEMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:12:34 -0400
Received: from stinky.trash.net ([213.144.137.162]:55814 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXIYEMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:12:33 -0400
Message-ID: <46F88881.1070908@trash.net>
Date: Tue, 25 Sep 2007 06:03:13 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Dan Merillat <dan.merillat@gmail.com>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [37/50] Fix inet_diag OOPS.
References: <20070924161246.983665021@mini.kroah.org>	 <20070924161733.GA13510@kroah.com> <20070924162206.GL13510@kroah.com> <a56dfcf00709241503j58cc8f82lbb581f29b17ab3d5@mail.gmail.com>
In-Reply-To: <a56dfcf00709241503j58cc8f82lbb581f29b17ab3d5@mail.gmail.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Merillat wrote:
> On 9/24/07, Greg KH <gregkh@suse.de> wrote:
> 
>>netlink_run_queue() doesn't handle multiple processes processing the
>>queue concurrently. Serialize queue processing in inet_diag to fix
>>a oops in netlink_rcv_skb caused by netlink_run_queue passing a
>>NULL for the skb.
> 
> 
> I just got this one on 2.6.23-RC1, looks the same to me but posting
> the oops anyway to doublecheck.
> 
> [1015205.245269] RIP: 0010:[<ffffffff804eb6a5>]  [<ffffffff804eb6a5>] netlink_run_queue+0xb2/0x104
> ...
> [1015205.245315] Call Trace:
> [1015205.245323]  [<ffffffff8819a024>] :inet_diag:inet_diag_rcv+0x24/0x2f


Yes, this is the same oops. Its fixed in the current -rc.
