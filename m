Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbZCXIty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbZCXIty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZCXItp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:49:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50725 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753378AbZCXIto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:49:44 -0400
Message-ID: <49C89EC2.5070009@cn.fujitsu.com>
Date: Tue, 24 Mar 2009 16:50:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] blktrace: fix off-by-one bug
References: <49C893FC.9080905@cn.fujitsu.com> <49C89447.5060303@cn.fujitsu.com> <20090324082754.GA13016@elte.hu> <49C89ACE.9070102@cn.fujitsu.com> <49C89CBC.4030600@cn.fujitsu.com> <20090324084717.GE13016@elte.hu>
In-Reply-To: <20090324084717.GE13016@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah. This:
> 
>         [__BLK_TA_QUEUE]        = {{  "Q", "queue" },      blk_log_generic },
>         [__BLK_TA_BACKMERGE]    = {{  "M", "backmerge" },  blk_log_generic },
>         [__BLK_TA_FRONTMERGE]   = {{  "F", "frontmerge" }, blk_log_generic },
>         [__BLK_TA_GETRQ]        = {{  "G", "getrq" },      blk_log_generic },
>         [__BLK_TA_SLEEPRQ]      = {{  "S", "sleeprq" },    blk_log_generic },
>         [__BLK_TA_REQUEUE]      = {{  "R", "requeue" },    blk_log_with_error },
>         [__BLK_TA_ISSUE]        = {{  "D", "issue" },      blk_log_generic },
>         [__BLK_TA_COMPLETE]     = {{  "C", "complete" },   blk_log_with_error },
>         [__BLK_TA_PLUG]         = {{  "P", "plug" },       blk_log_plug },
>         [__BLK_TA_UNPLUG_IO]    = {{  "U", "unplug_io" },  blk_log_unplug },
>         [__BLK_TA_UNPLUG_TIMER] = {{ "UT", "unplug_timer" }, blk_log_unplug },
>         [__BLK_TA_INSERT]       = {{  "I", "insert" },     blk_log_generic },
>         [__BLK_TA_SPLIT]        = {{  "X", "split" },      blk_log_split },
>         [__BLK_TA_BOUNCE]       = {{  "B", "bounce" },     blk_log_generic },
>         [__BLK_TA_REMAP]        = {{  "A", "remap" },      blk_log_remap },
> 
> does not have a __BLK_TA_ABORT entry currently - it should have, 
> right?
> 

Right, currently I'm not sure if blk_log_with_error is suitable for "abort" event,
so I haven't fixed it yet. :)
