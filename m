Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYKZRp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYKZRp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYKZRpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:45:13 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59911 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbYKZRpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:45:11 -0500
Date: Wed, 26 Nov 2008 09:44:39 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, daniel@hozac.com, xemul@openvz.org,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][v2] Define/use siginfo_from_ancestor_ns()
Message-ID: <20081126174439.GA427@us.ibm.com>
References: <20081115212133.GA32140@us.ibm.com> <20081118175336.GA14178@redhat.com> <20081119012207.GA19092@us.ibm.com> <20081123231014.GA2424@redhat.com> <20081126031619.GA19756@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126031619.GA19756@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| |    Actually, I think this is enough to solve most problems,
| |    the further changes can be discussed later. OK, the only
| |    "real" problem is SIGSTOP, afaics. This looks solveable.
| 
| Yes, SIGSTOP even from parent is ignored due to the SIGNAL_UNKILLABLE
| check in get_signal_to_deliver.

Actually with sig_task_ignored() patch, http://lkml.org/lkml/2008/11/18/251
SIGSTOP gets dropped early. To eventually allow SIGSTOP from ancestor ns,
we need to pass 'from_ancestor_ns' into sig_ignored() ?
