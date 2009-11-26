Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbZKZQ2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbZKZQ2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 11:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932562AbZKZQ2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 11:28:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55064 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbZKZQ16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 11:27:58 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH RFC v0 1/3] cgroup: implement eventfd-based generic API for notifications
Date: Thu, 26 Nov 2009 18:27:36 +0200
Message-Id: <bc4dc055a7307c8667da85a4d4d9d5d189af27d5.1259248846.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1259248846.git.kirill@shutemov.name>
References: <cover.1259248846.git.kirill@shutemov.name>
In-Reply-To: <cover.1259248846.git.kirill@shutemov.name>
References: <cover.1259248846.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces write-only file "cgroup.event_control" in every
cgroup.

To register new notification handler you need:
- create an eventfd;
- open a control file to be monitored. Callbacks register_event() and
  unregister_event() must be defined for the control file;
- write "<event_fd> <control_fd> <args>" to cgroup.event_control.
  Interpretation of args is defined by control file implementation;

eventfd will be woken up by control file implementation or when the
cgroup is removed.

To unregister notification handler just close eventfd.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
1.6.5.3

