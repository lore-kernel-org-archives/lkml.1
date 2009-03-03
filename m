Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZCCBO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZCCBO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 20:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZCCBOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 20:14:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59981 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZCCBOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 20:14:48 -0500
Message-ID: <49AC84BE.5020501@cn.fujitsu.com>
Date: Tue, 03 Mar 2009 09:15:42 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] cgroups: show correct file mode
References: <49AB40BF.4030706@cn.fujitsu.com>	<6599ad830903021019p3b29c173oc7772af6679d90e0@mail.gmail.com>	<49AC8307.7090008@cn.fujitsu.com> <20090303100827.43d82c3a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090303100827.43d82c3a.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +/**
>> + * cgroup_file_mode - deduce file mode of a control file
>> + * @cft: the control file in question
>> + *
>> + * returns cftype->mode if ->mode is not 0
>> + * returns 0644 if it has both a read and a write handler
>> + * returns 0444 if it has only a read handler
>> + * returns 0200 if it has only a write hander
>> + */
>> +static int cgroup_file_mode(const struct cftype *cft)
>> +{
>> +	int mode = 0;
>> +
>> +	if (cft->mode)
>> +		return cft->mode;
>> +
>> +	if (cft->read || cft->read_u64 || cft->read_s64 ||
>> +	    cft->read_map || cft->read_seq_string)
>> +		mode += 0444;
>> +
>> +	if (cft->write || cft->write_u64 || cft->write_s64 ||
>> +	    cft->write_string || cft->trigger)
>> +		mode += 0200;
>> +
> 
> += is not |=...
> 

Ah, yes, though both happen to result in 0644.

