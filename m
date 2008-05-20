Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbYETRJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbYETRJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYETRI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:08:59 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:57223 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbYETRI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:08:58 -0400
Message-ID: <483305A6.3040906@kerlabs.com>
Date: Tue, 20 May 2008 19:08:54 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
Organization: Kerlabs
User-Agent: IceDove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Joel.Becker@oracle.com, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [RFC][PATCH 0/3] configfs: Make nested default groups lockdep-friendly
References: <20080520163320.025971210@kerlabs.com> <20080520095810.1d50d247@infradead.org>
In-Reply-To: <20080520095810.1d50d247@infradead.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven a écrit :
> On Tue, 20 May 2008 18:33:20 +0200
> Louis Rilling <Louis.Rilling@kerlabs.com> wrote:
> 
>> Hi all,
>>
>> The following patches fix lockdep warnings resulting from (correct)
>> recursive locking in configfs.
>>
>> Current lockdep annotations for inode mutexes in configfs are
>> lockdep-friendly provided that:
>> 1/ config_groups have at most one level of default groups (see
>>    configfs_attach_group()),
>> 2/ config_groups having default groups are never removed (see
>>    configfs_detach_prep()).
>>
>> Since lockdep does not handle such correct recursion, the idea is to
>> insert lockdep_off()/lockdep_on() for inode mutexes as soon as the
>> level of recursion of the I_MUTEX_PARENT -> I_MUTEX_CHILD dependency
>> pattern increases.
> 
> I'm... not entirely happy with such a solution ;(
> 
> there must be a better one.

Hmm, to me there are three solutions:

1/ keep lockdep and configfs like they are, and use this patchset

2/ enhance lockdep to handle wariable-depth but correct recursion:
seems uncertain...


3/ remove this recursive locking from configfs:
unfortunately, it seems that there are a good reasons for doing
recursive inode locking, at least when removing a config_group with
default groups. So, seems uncertain too...

Other ideas?

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
