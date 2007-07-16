Return-Path: <linux-kernel-owner+w=401wt.eu-S1760519AbXGPSvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbXGPSvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 14:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbXGPSuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 14:50:55 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:42041 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXGPSuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 14:50:54 -0400
Message-ID: <469BBE00.8000709@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2007 00:20:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Pavel Emelianov <xemul@sw.ru>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>, Paul Jackson <pj@sgi.com>
Subject: Containers: css_put() dilemma
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Paul,

I've run into a strange problem with css_put(). After the changes for notify_on_release(), the css_put() routine can now block and it blocks on
the container_mutex. This implies that css_put() cannot be called if

1. We cannot block
2. We already hold the container_mutex

The problem I have is that of preventing the destruction of my container
(when the user does rmdir). If the user migrates away all tasks and does
an rmdir, the only way to prevent the container from going away is through
css_get() references. In my case, some pages have been allocated from the
container and hence I do not want it to go away, until all the pages
charged to it are freed. When I use css_get/put() to prevent destruction
I am blocked by the limitations of css_put() listed above.

Do you have any recommendations for a cleaner solution? I suspect we'll
need can_destroy() callbacks (similar to can_attach()).

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
