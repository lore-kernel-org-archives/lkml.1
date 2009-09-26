Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZIZO1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZIZO1o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 10:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZIZO1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 10:27:43 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58430 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbZIZO1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 10:27:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=HUP1ziGtwFATSNVjf49duBMUVChZ5Ja3w+JVFFc/GrYmXgFI3c1nJTsR8GwHidmZJQ
         KanEcyhMJxljMRQD8PaA0sOXKHopKEGKTpxGO6abxALbT86Ti/k9t4hRWhzxhRJX7dc5
         lFZj2EdpWvDiPrelCdYElSQd0rtbu0LuFVl4U=
MIME-Version: 1.0
In-Reply-To: <20090919231810.GE7121@mit.edu>
References: <a769871e0909191112t3adb852cn93d72dc5fd94b9fd@mail.gmail.com>
	 <20090919231810.GE7121@mit.edu>
Date: Sat, 26 Sep 2009 16:27:46 +0200
Message-ID: <a769871e0909260727l65fd04a8ud49a9e0e0ec7d9a6@mail.gmail.com>
Subject: Re: EXT4 RAID read performance
From: wbrana@gmail.com
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 1:18 AM, Theodore Tso <tytso@mit.edu> wrote:
> You didn't say which version of the kernel you are using, which could
> be important when asking these sorts of questions about potential
> performance problems.
>
2.6.31

>
> Now, there are some workloads which compilebench might accurately
> model --- for example, tar'ing up a directory.  However, despite the
> name of the benchmark, it doesn't accurately model a kernel compile.
>

You are right. I created simple benchmark which does real compilation of kernel
with following results:

reiser3
16925 msec: tar xf /usr/src/linux.tar
119173 msec: make -j4 all

ext4
14296 msec: tar xf /usr/src/linux.tar
116692 msec: make -j4 all

btrfs
13493 msec: tar xf /usr/src/linux.tar
116015 msec: make -j4 all

MD RAID10-f2 with 256 kB chunk size was used in all cases.

Source code:
http://www.sendspace.com/file/fmikv7
It depends on Qt Core library. There are hard-coded paths.
It can delete important data if it is started without customization !!!
