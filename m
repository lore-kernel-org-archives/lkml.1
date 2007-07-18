Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbXGRO57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbXGRO57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbXGRO5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:57:52 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:42697 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXGRO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=k0hfy0mEFHPy1yNusp1VOZz1y/aJS93Rrr8HeG8qD/h8gI/jQJ94rnZQjJC1KOyDhyUrkt5Rj1WEi1ERHstxqp3yMlYgwJEpj7tz2qgCWLk/M9X78P4zKcv9TAruyH6piC09u++h2rYguXbnvbr2TEYGhI+aFHWK5alO0y5I79g=
Message-ID: <469E2A68.6010307@gmail.com>
Date: Wed, 18 Jul 2007 23:57:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure
 path
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com>	 <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>	 <20070718071445.GI23568@htj.dyndns.org> <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
In-Reply-To: <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
>> There is a subtle bug in sysfs_create_link() failure path.  When
>> symlink creation fails because there's already a node with the same
>> name, the target sysfs_dirent is put twice - once by failure path of
>> sysfs_create_link() and once more when the symlink is released.
> 
> The "symlink" is released? But the creation of the symlink is
> precisely what failed here ... did it not?
> 
>> Fix it by making only the symlink node responsible for putting
>> target_sd.
> 
> And again ... the changelog sounds confusing indeed, perhaps I'm
> not familiar enough with sysfs symlink-related terminology/semantics.
> Care to elaborate?
> 
>>         sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
>>         if (!sd)
>>                 goto out_put;
>> +
>>         sd->s_elem.symlink.target_sd = target_sd;
>> +       target_sd = NULL;       /* reference is now owned by the
>> symlink */
> 
> Wow. This looks like a very mysterious way to fix a mysterious bug :-)
> BTW I just looked over at sysfs_create_link() and ... it looks quite ...
> unnecessarily complicated/obfuscated ...

Well, I dunno.  Probably my taste just sucks.  Please feel free to
submit patches and/or suggest better ideas.

-- 
tejun
