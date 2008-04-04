Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYDDGVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYDDGVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYDDGVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:21:05 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40056 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYDDGVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:21:03 -0400
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: "'Paul Menage'" <menage@google.com>, <linux-kernel@vger.kernel.org>,
       <containers@lists.linux-foundation.org>
Cc: <axboe@kernel.dk>, <tom-sugawara@ap.jp.nec.com>,
       <m-takahashi@ex.jp.nec.com>
References: <007801c893d9$d89726f0$89c574d0$@jp.nec.com>	 <008501c893dc$3206e520$9614af60$@jp.nec.com> <6599ad830804030835s73392db0v29426425c0ea4381@mail.gmail.com>
In-Reply-To: <6599ad830804030835s73392db0v29426425c0ea4381@mail.gmail.com>
Subject: RE: [RFC][patch 8/11][CFQ-cgroup] Control cfq_data per cgroup
Date: Fri, 4 Apr 2008 15:20:39 +0900
Message-Id: <003401c8961c$00eea670$02cbf350$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciVoFAGF6puaLoEQvKHjHc38snNPgAc3rdA
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

\> 
> On Tue, Apr 1, 2008 at 2:38 AM, Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
> wrote:
> >  +
> >  +static void *cfq_cgroup_init_cfq_data(struct cfq_cgroup *cfqc, struct
> cfq_data *cfqd)
> >  +{
> >  +       struct cgroup *child;
> >  +
> >  +       /* setting cfq_data for cfq_cgroup */
> >  +       if (!cfqc) {
> >  +               cfqc =
> cgroup_to_cfq_cgroup(get_root_subsys(&cfq_cgroup_subsys));
> 
> Rather than adding get_root_subsys(), can't you just keep a reference
> locally to your root subsystem state?
> 


If the cfqc has not specific address, namely cfqc is null, 
the cfq_cgroup_init_cfq_data function is called when new device is plugged.
In this time, it needs to relate new cfq_data data with top cfq_cgroup data.
Probably, a running program will be "insmod" in its time.
However, its program is not in root group.

On the supposition that only current interface is usedm,
If using current process, the top cgroup can be calculated by

   task_cgroup(current, cfq_subsys_id)->top_cgroup .

Therefore cfq_cgroup data of top cgroup is calculated by

   cgroup_to_cfq_cgroup(task_cgroup(current, cfq_subsys_id)->top_cgroup) .


However,  It would be bad to use "current" variable in order to
calculate cfq_cgroup data of top cgroup.
Because relationship between "calculating cfq_cgroup data of top cgroup" and
"running(current) task" is weak.


So that you say, root subsystem state maybe keep a reference locally.
For example, create a variable for root subsystem state and
store the pointer when making subsystem state first.

However, I think that it is smart to calculate root group of subsystems
when needing its information.
Does the current code have any problem?


Satoshi UCHIDA.

