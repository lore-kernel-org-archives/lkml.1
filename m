Return-Path: <linux-kernel-owner+w=401wt.eu-S970029AbXFHQJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970029AbXFHQJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968811AbXFHQIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:08:51 -0400
Received: from smtp104.sbc.mail.re2.yahoo.com ([68.142.229.101]:21549 "HELO
	smtp104.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S969805AbXFHQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:08:49 -0400
X-YMail-OSG: 0xqXWSUVM1nd0tPzH4TmPVUI5XoHf007l7XE4hEMy_5B1JBBhkbD0YeAMfZCDsNFfF2.9T6fU9Apq36Y9Ngi29hhT0PeLeiM7e072u.Ejx69sRhPE2YqfGLURSQDm6JsEb3N2T89jUCq2g--
Date: Fri, 8 Jun 2007 11:08:40 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Paul Jackson <pj@sgi.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       rohitseth@google.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, cpw@sgi.com, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070608160840.GA11133@vino.hallyn.com>
References: <20070606223952.GB5626@sergelap.austin.ibm.com> <20070606154347.a155630b.pj@sgi.com> <20070607000559.GA19529@sergelap.austin.ibm.com> <20070606174609.bfa01446.pj@sgi.com> <20070607180158.GA936@sergelap.austin.ibm.com> <20070607122121.24fe6ff4.pj@sgi.com> <20070607201723.GA17011@sergelap.austin.ibm.com> <20070607150113.f020d8f8.pj@sgi.com> <20070608143250.GA7728@vino.hallyn.com> <6599ad830706080855n22612814u4805d34a295b165f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830706080855n22612814u4805d34a295b165f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 6/8/07, Serge E. Hallyn <serge@hallyn.com> wrote:
> >
> >Anyway the patch I sent is simple enough, and if users end up demanding
> >the ability to better deal with exclusive cpusets, the patch will be
> >simple enough to extend by changing cpuset_auto_setup(), so let's
> >stick with that patch since it's your preference (IIUC).
> >
> 
> Sounds good to me, although I think my preference would be to extend
> the "create()" subsystem callback with a "struct task_struct
> *clone_task" parameter that indicates that clone_task is cloning its
> own container; a subsystem like cpusets that needs to do additional
> setup at that point could inherit settings either from the parent or
> from clone_task's container (or something else) as desired. (It could
> also do permission checking based on properties of clone_task, etc).

The problem is container_clone() doesn't call ->create explicitly, it
does vfs_mkdir.  So we have no real way of passing in clone_task.

-serge
