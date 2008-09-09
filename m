Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYIIMqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYIIMqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYIIMqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:46:06 -0400
Received: from sh.osrg.net ([192.16.179.4]:45363 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbYIIMqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:46:04 -0400
Date: Tue, 9 Sep 2008 21:45:39 +0900
To: jens.axboe@oracle.com
Cc: eo@nebensachen.de, fujita.tomonori@lab.ntt.co.jp, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: Block: Trouble with kobject initialisation for blk_cmd_filter
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080909102844.GD20055@kernel.dk>
References: <87od3235fc.fsf@denkblock.local>
	<20080909102844.GD20055@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080909214602L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 12:28:45 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, Sep 05 2008, Elias Oltmanns wrote:
> > Hi all,
> > 
> > current usage of the kobject in struct blk_cmd_filter is flawed. Doing
> > # modprobe -r sd-mod && modprobe sd-mod
> > while, for instance, a usb-stick is plugged in currently results in
> > nasty warnings and a dump_stack(). Since blk_cmd_filter is embedded in
> > struct request_queue, I don't see the need for a kobject anyway. What
> > about the much simpler option of a struct attribute_group in this
> > particular case?
> > 
> > This would imply that the cmd_filter subdirectory would appear under
> > sda/queue/ rather than sda/ (which is probably the right place) but,
> > alas, we have to keep compatibility in mind. So I've made some changes
> > to sysfs along the way in order to provide a legacy symlink. I'd have to
> > seperate these two changes for submission but I wanted to know your
> > opinion about it all first.
> > 
> > Thinking about it now makes me wonder whether this is too much for a rc
> > patch and whether we should just allocate the struct blk_cmd_filter
> > dynamically and have done with it. Anyway, tell me what you think.
> 
> I think this patch is a step in the right direction, lets get rid of
> that pesky kobject just for the cmdfilter. Can you resend the patch
> _without_ the sysfs changes and link support? We haven't released a
> kernel with cmd filter support yet, so we can change the location still
> and not have to worry about compatability.

The sysfs changes looks too much for 2.6.27-rcX but without the sysfs
changes, we have the cmdfilter under /sys/block/sda/queue/, right? We
don't need to worry about compatibility, but /sys/block/sda is more
appropriate? (though I don't think that the cmd filter is a good idea
so I don't care much).

Jens, would it be better to just disable the cmdfilter stuff for
2.6.27? It's too late for another try to fix this broken stuff, I
guess.
