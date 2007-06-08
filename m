Return-Path: <linux-kernel-owner+w=401wt.eu-S1031031AbXFHRO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031031AbXFHRO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030777AbXFHROD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:14:03 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:47997 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030628AbXFHRN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:13:59 -0400
Message-ID: <46698E50.6030108@de.ibm.com>
Date: Fri, 08 Jun 2007 19:13:52 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, jbaron@redhat.com, rostedt@goodmis.org,
       billh@gnuppy.monkey.org, mingo@elte.hu, linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <1181202683.7348.220.camel@twins>
In-Reply-To: <1181202683.7348.220.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2007-06-06 at 23:34 +0200, Martin Peschke wrote:
> 
>> +struct statistic_info lock_stat_info[_LOCK_STAT_NUMBER] = {
>> +	[LOCK_STAT_CONT] = {
>> +		.name	  = "contentions",
>> +		.x_unit	  = "instruction_pointer",
>> +		.y_unit	  = "occurrence",
>> +		.defaults = "type=sparse entries=4",
>> +		.flags	  = STATISTIC_FLAGS_LABEL,
>> +	},
>> +	[LOCK_STAT_WAIT_READ] = {
>> +		.name	  = "wait_read",
>> +		.x_unit	  = "nanoseconds",
>> +		.y_unit	  = "occurrence",
>> +		.defaults = "type=utilisation",
>> +	},
>> +	[LOCK_STAT_WAIT_WRITE] = {
>> +		.name	  = "wait_write",
>> +		.x_unit	  = "nanoseconds",
>> +		.y_unit	  = "occurrence",
>> +		.defaults = "type=utilisation",
>> +	},
>> +	[LOCK_STAT_HOLD_READ] = {
>> +		.name	  = "hold_read",
>> +		.x_unit	  = "nanoseconds",
>> +		.y_unit	  = "occurrence",
>> +		.defaults = "type=utilisation",
>> +	},
>> +	[LOCK_STAT_HOLD_WRITE] = {
>> +		.name	  = "hold_write",
>> +		.x_unit	  = "nanoseconds",
>> +		.y_unit	  = "occurrence",
>> +		.defaults = "type=utilisation",
>>  	}
>>  };
> 
> You're parsing strings in-kernel to setup data structures?

Might be surprising (or revolting?)... but, yes, I do.

.defaults reflects the developers opinion on the way of data
accumululation that might make most sense in most cases.
The current implementation of lib/statistic.c allows users to change
setting that we see in .defaults. If one needs to track more than
4 contention points, for example, then they can change this limit by
passing "entries=4" to the user interface. So there is some parsing
code anyway. Passing default setting in a similar fashion has just been
convenient for the developer.

