Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbYDQESM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbYDQESM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbYDQERy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:17:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:50835 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYDQERw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:17:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: Possible mem leak in copy_process()
Date: Thu, 17 Apr 2008 06:17:34 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com>
In-Reply-To: <alpine.LNX.1.00.0804162336480.9837@dragon.funnycrock.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804170617.36010.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19+RIZ+TwMl70WfFSYzMgnnG6D0uhz5UPyZmC8
 0SbwFe8YGs847wY2AXOpxKxLVKNnqTAZNbdHjKKqGtn0GvUxcu
 WhI6wSOd8klzWNVjo0/HA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Jesper Juhl wrote:
> 
> Perhaps it can never happen the way Coverity thinks it can. You are a much 
> better judge of that than I, but it looks to me like it's at least 
> possible in theory - in which case we have a potential leak every time we 
> create a new process and that can't be good...

I think you're just looking at the common case here, which is correct:
The pid is allocated for task creation and stays around as long as the
task does. It gets freed when the last reference to it goes away,
usually in the put_pid() called from exit().

	Arnd <><
