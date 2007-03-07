Return-Path: <linux-kernel-owner+w=401wt.eu-S965656AbXCGVUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965656AbXCGVUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965657AbXCGVUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:20:33 -0500
Received: from smtp-out.google.com ([216.239.33.17]:41509 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965656AbXCGVUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:20:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=x5oqphJQqGNqsvr7OOU1qBBttQtchgaALohZzFLgA/XbEZ5jhy1Zr2Zhvz54GAU+b
	annCm8vmGoJB8QNJ+VDow==
Message-ID: <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
Date: Wed, 7 Mar 2007 13:20:18 -0800
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, ebiederm@xmission.com,
       sam@vilain.net, akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru,
       xemul@sw.ru, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070307205846.GB7010@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	 <20070307173031.GC2336@in.ibm.com>
	 <20070307174346.GA19521@sergelap.austin.ibm.com>
	 <20070307180055.GC17151@in.ibm.com>
	 <20070307205846.GB7010@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
> All that being said, if it were going to save space without overly
> complicating things I'm actually not opposed to using nsproxy, but it

If space-saving is the main issue, then the latest version of my
containers patches uses just a single pointer in the task_struct, and
all tasks in the same set of containers (across all hierarchies) will
share a single container_group object, which holds the actual pointers
to container state.

Effectively, container_group is to container as nsproxy is to namespace.

Paul
