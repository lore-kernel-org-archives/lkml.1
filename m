Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYAUIsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYAUIsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbYAUIsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:48:15 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757775AbYAUIsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:48:15 -0500
From: "Li Xiaodong" <lixd@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
Subject: [HELP]Problem with exit(0) and _exit(0) on RHEL x86
Date: Mon, 21 Jan 2008 16:40:21 +0800
Message-ID: <007501c85c09$420a6e20$978da70a@fujitsulixd>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AchcCUHMo5xtUGjSSJKrcRBFW98pzQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I thought the effects of exit(0) and _exit(0) should be different.

----
int main(void)
{
        int var = 0;
        pid_t pid;

        printf("before vfork\n");
        if ( (pid = vfork()) < 0 )
                printf("error\n");
        else if ( pid == 0 )
        {
                var++;
                exit(0);  /* Clear parent's IO */
        }

        printf("%d\n",var);
        return 0;
}

----

int main(void)
{
        int var = 0;
        pid_t pid;

        printf("before vfork\n");
        if ( (pid = vfork()) < 0 )
                printf("error\n");
        else if ( pid == 0 )
        {
                var++;
                _exit(0);  /* Do not clear parent's IO */
        }

        printf("%d\n",var);
        return 0;
}

----

But the actual results on RHEL5 x86 were beyond my ken. The outputs of the
above two are the same. 

$./a.out
before vfork
1

Could anyone help me with this? Thanks.



