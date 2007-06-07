Return-Path: <linux-kernel-owner+w=401wt.eu-S965945AbXFGAcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965945AbXFGAcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbXFGAck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:32:40 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:44277 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbXFGAcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:32:39 -0400
Message-ID: <46675222.9000304@de.ibm.com>
Date: Thu, 07 Jun 2007 02:32:34 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Dave Hansen <hansendc@us.ibm.com>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jbaron@redhat.com,
       rostedt@goodmis.org, billh@gnuppy.monkey.org, mingo@elte.hu,
       linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 1/4] statistics: no include hell for users
References: <1181165609.7133.20.camel@dix> <1181165987.22388.81.camel@spirit.sr71.net>
In-Reply-To: <1181165987.22388.81.camel@spirit.sr71.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Wed, 2007-06-06 at 23:33 +0200, Martin Peschke wrote:
>>  struct statistic_interface {
>>  /* private: */
>>         struct list_head         list;
>> -       struct dentry           *debugfs_dir;
>> -       struct dentry           *data_file;
>> -       struct dentry           *def_file;
>> +       void                    *debugfs_dir;
>> +       void                    *data_file;
>> +       void                    *def_file; 
> 
> If you don't actually dereference the pointer, you should just be able
> to declare:
> 
> 	struct dentry;
> 
> and be done with it, right?  You don't _need_ the includes to have just
> pointers.

Ah, looks like an established trick in kernel include files.
I guess I can revert the other, seq_file related change then as well.
Thank you. Will change my local copy.

Martin

