Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbXDZGJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbXDZGJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXDZGJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:09:05 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:39763 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbXDZGJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:09:01 -0400
Date: Thu, 26 Apr 2007 02:08:57 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 07/12] selinux: remove userland security class and permission
 definitions
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260208290.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

Remove userland security class and permission definitions from the kernel
as the kernel only needs to use and validate its own class and permission
definitions and userland definitions may change.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/avc.c                       |    2 +
 security/selinux/include/av_perm_to_string.h |  102 ---------------
 security/selinux/include/av_permissions.h    |  179 --------------------------
 security/selinux/include/class_to_string.h   |   34 +++---
 security/selinux/include/flask.h             |   16 ---
 security/selinux/ss/services.c               |    2 +
 6 files changed, 21 insertions(+), 314 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index da8caf1..e4396a8 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -217,6 +217,8 @@ static void avc_dump_query(struct audit_buffer *ab, u32 ssid, u32 tsid, u16 tcla
 		audit_log_format(ab, " tcontext=%s", scontext);
 		kfree(scontext);
 	}
+
+	BUG_ON(tclass >= ARRAY_SIZE(class_to_string) || !class_to_string[tclass]);
 	audit_log_format(ab, " tclass=%s", class_to_string[tclass]);
 }
 
diff --git a/security/selinux/include/av_perm_to_string.h b/security/selinux/include/av_perm_to_string.h
index ad9fb2d..b83e740 100644
--- a/security/selinux/include/av_perm_to_string.h
+++ b/security/selinux/include/av_perm_to_string.h
@@ -128,96 +128,6 @@
    S_(SECCLASS_CAPABILITY, CAPABILITY__LEASE, "lease")
    S_(SECCLASS_CAPABILITY, CAPABILITY__AUDIT_WRITE, "audit_write")
    S_(SECCLASS_CAPABILITY, CAPABILITY__AUDIT_CONTROL, "audit_control")
-   S_(SECCLASS_PASSWD, PASSWD__PASSWD, "passwd")
-   S_(SECCLASS_PASSWD, PASSWD__CHFN, "chfn")
-   S_(SECCLASS_PASSWD, PASSWD__CHSH, "chsh")
-   S_(SECCLASS_PASSWD, PASSWD__ROOTOK, "rootok")
-   S_(SECCLASS_PASSWD, PASSWD__CRONTAB, "crontab")
-   S_(SECCLASS_DRAWABLE, DRAWABLE__CREATE, "create")
-   S_(SECCLASS_DRAWABLE, DRAWABLE__DESTROY, "destroy")
-   S_(SECCLASS_DRAWABLE, DRAWABLE__DRAW, "draw")
-   S_(SECCLASS_DRAWABLE, DRAWABLE__COPY, "copy")
-   S_(SECCLASS_DRAWABLE, DRAWABLE__GETATTR, "getattr")
-   S_(SECCLASS_GC, GC__CREATE, "create")
-   S_(SECCLASS_GC, GC__FREE, "free")
-   S_(SECCLASS_GC, GC__GETATTR, "getattr")
-   S_(SECCLASS_GC, GC__SETATTR, "setattr")
-   S_(SECCLASS_WINDOW, WINDOW__ADDCHILD, "addchild")
-   S_(SECCLASS_WINDOW, WINDOW__CREATE, "create")
-   S_(SECCLASS_WINDOW, WINDOW__DESTROY, "destroy")
-   S_(SECCLASS_WINDOW, WINDOW__MAP, "map")
-   S_(SECCLASS_WINDOW, WINDOW__UNMAP, "unmap")
-   S_(SECCLASS_WINDOW, WINDOW__CHSTACK, "chstack")
-   S_(SECCLASS_WINDOW, WINDOW__CHPROPLIST, "chproplist")
-   S_(SECCLASS_WINDOW, WINDOW__CHPROP, "chprop")
-   S_(SECCLASS_WINDOW, WINDOW__LISTPROP, "listprop")
-   S_(SECCLASS_WINDOW, WINDOW__GETATTR, "getattr")
-   S_(SECCLASS_WINDOW, WINDOW__SETATTR, "setattr")
-   S_(SECCLASS_WINDOW, WINDOW__SETFOCUS, "setfocus")
-   S_(SECCLASS_WINDOW, WINDOW__MOVE, "move")
-   S_(SECCLASS_WINDOW, WINDOW__CHSELECTION, "chselection")
-   S_(SECCLASS_WINDOW, WINDOW__CHPARENT, "chparent")
-   S_(SECCLASS_WINDOW, WINDOW__CTRLLIFE, "ctrllife")
-   S_(SECCLASS_WINDOW, WINDOW__ENUMERATE, "enumerate")
-   S_(SECCLASS_WINDOW, WINDOW__TRANSPARENT, "transparent")
-   S_(SECCLASS_WINDOW, WINDOW__MOUSEMOTION, "mousemotion")
-   S_(SECCLASS_WINDOW, WINDOW__CLIENTCOMEVENT, "clientcomevent")
-   S_(SECCLASS_WINDOW, WINDOW__INPUTEVENT, "inputevent")
-   S_(SECCLASS_WINDOW, WINDOW__DRAWEVENT, "drawevent")
-   S_(SECCLASS_WINDOW, WINDOW__WINDOWCHANGEEVENT, "windowchangeevent")
-   S_(SECCLASS_WINDOW, WINDOW__WINDOWCHANGEREQUEST, "windowchangerequest")
-   S_(SECCLASS_WINDOW, WINDOW__SERVERCHANGEEVENT, "serverchangeevent")
-   S_(SECCLASS_WINDOW, WINDOW__EXTENSIONEVENT, "extensionevent")
-   S_(SECCLASS_FONT, FONT__LOAD, "load")
-   S_(SECCLASS_FONT, FONT__FREE, "free")
-   S_(SECCLASS_FONT, FONT__GETATTR, "getattr")
-   S_(SECCLASS_FONT, FONT__USE, "use")
-   S_(SECCLASS_COLORMAP, COLORMAP__CREATE, "create")
-   S_(SECCLASS_COLORMAP, COLORMAP__FREE, "free")
-   S_(SECCLASS_COLORMAP, COLORMAP__INSTALL, "install")
-   S_(SECCLASS_COLORMAP, COLORMAP__UNINSTALL, "uninstall")
-   S_(SECCLASS_COLORMAP, COLORMAP__LIST, "list")
-   S_(SECCLASS_COLORMAP, COLORMAP__READ, "read")
-   S_(SECCLASS_COLORMAP, COLORMAP__STORE, "store")
-   S_(SECCLASS_COLORMAP, COLORMAP__GETATTR, "getattr")
-   S_(SECCLASS_COLORMAP, COLORMAP__SETATTR, "setattr")
-   S_(SECCLASS_PROPERTY, PROPERTY__CREATE, "create")
-   S_(SECCLASS_PROPERTY, PROPERTY__FREE, "free")
-   S_(SECCLASS_PROPERTY, PROPERTY__READ, "read")
-   S_(SECCLASS_PROPERTY, PROPERTY__WRITE, "write")
-   S_(SECCLASS_CURSOR, CURSOR__CREATE, "create")
-   S_(SECCLASS_CURSOR, CURSOR__CREATEGLYPH, "createglyph")
-   S_(SECCLASS_CURSOR, CURSOR__FREE, "free")
-   S_(SECCLASS_CURSOR, CURSOR__ASSIGN, "assign")
-   S_(SECCLASS_CURSOR, CURSOR__SETATTR, "setattr")
-   S_(SECCLASS_XCLIENT, XCLIENT__KILL, "kill")
-   S_(SECCLASS_XINPUT, XINPUT__LOOKUP, "lookup")
-   S_(SECCLASS_XINPUT, XINPUT__GETATTR, "getattr")
-   S_(SECCLASS_XINPUT, XINPUT__SETATTR, "setattr")
-   S_(SECCLASS_XINPUT, XINPUT__SETFOCUS, "setfocus")
-   S_(SECCLASS_XINPUT, XINPUT__WARPPOINTER, "warppointer")
-   S_(SECCLASS_XINPUT, XINPUT__ACTIVEGRAB, "activegrab")
-   S_(SECCLASS_XINPUT, XINPUT__PASSIVEGRAB, "passivegrab")
-   S_(SECCLASS_XINPUT, XINPUT__UNGRAB, "ungrab")
-   S_(SECCLASS_XINPUT, XINPUT__BELL, "bell")
-   S_(SECCLASS_XINPUT, XINPUT__MOUSEMOTION, "mousemotion")
-   S_(SECCLASS_XINPUT, XINPUT__RELABELINPUT, "relabelinput")
-   S_(SECCLASS_XSERVER, XSERVER__SCREENSAVER, "screensaver")
-   S_(SECCLASS_XSERVER, XSERVER__GETHOSTLIST, "gethostlist")
-   S_(SECCLASS_XSERVER, XSERVER__SETHOSTLIST, "sethostlist")
-   S_(SECCLASS_XSERVER, XSERVER__GETFONTPATH, "getfontpath")
-   S_(SECCLASS_XSERVER, XSERVER__SETFONTPATH, "setfontpath")
-   S_(SECCLASS_XSERVER, XSERVER__GETATTR, "getattr")
-   S_(SECCLASS_XSERVER, XSERVER__GRAB, "grab")
-   S_(SECCLASS_XSERVER, XSERVER__UNGRAB, "ungrab")
-   S_(SECCLASS_XEXTENSION, XEXTENSION__QUERY, "query")
-   S_(SECCLASS_XEXTENSION, XEXTENSION__USE, "use")
-   S_(SECCLASS_PAX, PAX__PAGEEXEC, "pageexec")
-   S_(SECCLASS_PAX, PAX__EMUTRAMP, "emutramp")
-   S_(SECCLASS_PAX, PAX__MPROTECT, "mprotect")
-   S_(SECCLASS_PAX, PAX__RANDMMAP, "randmmap")
-   S_(SECCLASS_PAX, PAX__RANDEXEC, "randexec")
-   S_(SECCLASS_PAX, PAX__SEGMEXEC, "segmexec")
    S_(SECCLASS_NETLINK_ROUTE_SOCKET, NETLINK_ROUTE_SOCKET__NLMSG_READ, "nlmsg_read")
    S_(SECCLASS_NETLINK_ROUTE_SOCKET, NETLINK_ROUTE_SOCKET__NLMSG_WRITE, "nlmsg_write")
    S_(SECCLASS_NETLINK_FIREWALL_SOCKET, NETLINK_FIREWALL_SOCKET__NLMSG_READ, "nlmsg_read")
@@ -232,16 +142,6 @@
    S_(SECCLASS_NETLINK_AUDIT_SOCKET, NETLINK_AUDIT_SOCKET__NLMSG_READPRIV, "nlmsg_readpriv")
    S_(SECCLASS_NETLINK_IP6FW_SOCKET, NETLINK_IP6FW_SOCKET__NLMSG_READ, "nlmsg_read")
    S_(SECCLASS_NETLINK_IP6FW_SOCKET, NETLINK_IP6FW_SOCKET__NLMSG_WRITE, "nlmsg_write")
-   S_(SECCLASS_DBUS, DBUS__ACQUIRE_SVC, "acquire_svc")
-   S_(SECCLASS_DBUS, DBUS__SEND_MSG, "send_msg")
-   S_(SECCLASS_NSCD, NSCD__GETPWD, "getpwd")
-   S_(SECCLASS_NSCD, NSCD__GETGRP, "getgrp")
-   S_(SECCLASS_NSCD, NSCD__GETHOST, "gethost")
-   S_(SECCLASS_NSCD, NSCD__GETSTAT, "getstat")
-   S_(SECCLASS_NSCD, NSCD__ADMIN, "admin")
-   S_(SECCLASS_NSCD, NSCD__SHMEMPWD, "shmempwd")
-   S_(SECCLASS_NSCD, NSCD__SHMEMGRP, "shmemgrp")
-   S_(SECCLASS_NSCD, NSCD__SHMEMHOST, "shmemhost")
    S_(SECCLASS_ASSOCIATION, ASSOCIATION__SENDTO, "sendto")
    S_(SECCLASS_ASSOCIATION, ASSOCIATION__RECVFROM, "recvfrom")
    S_(SECCLASS_ASSOCIATION, ASSOCIATION__SETCONTEXT, "setcontext")
@@ -256,7 +156,5 @@
    S_(SECCLASS_KEY, KEY__LINK, "link")
    S_(SECCLASS_KEY, KEY__SETATTR, "setattr")
    S_(SECCLASS_KEY, KEY__CREATE, "create")
-   S_(SECCLASS_CONTEXT, CONTEXT__TRANSLATE, "translate")
-   S_(SECCLASS_CONTEXT, CONTEXT__CONTAINS, "contains")
    S_(SECCLASS_DCCP_SOCKET, DCCP_SOCKET__NODE_BIND, "node_bind")
    S_(SECCLASS_DCCP_SOCKET, DCCP_SOCKET__NAME_CONNECT, "name_connect")
diff --git a/security/selinux/include/av_permissions.h b/security/selinux/include/av_permissions.h
index 2de4b5f..5fee173 100644
--- a/security/selinux/include/av_permissions.h
+++ b/security/selinux/include/av_permissions.h
@@ -16,7 +16,6 @@
 #define COMMON_FILE__SWAPON                              0x00004000UL
 #define COMMON_FILE__QUOTAON                             0x00008000UL
 #define COMMON_FILE__MOUNTON                             0x00010000UL
-
 #define COMMON_SOCKET__IOCTL                             0x00000001UL
 #define COMMON_SOCKET__READ                              0x00000002UL
 #define COMMON_SOCKET__WRITE                             0x00000004UL
@@ -39,7 +38,6 @@
 #define COMMON_SOCKET__RECV_MSG                          0x00080000UL
 #define COMMON_SOCKET__SEND_MSG                          0x00100000UL
 #define COMMON_SOCKET__NAME_BIND                         0x00200000UL
-
 #define COMMON_IPC__CREATE                               0x00000001UL
 #define COMMON_IPC__DESTROY                              0x00000002UL
 #define COMMON_IPC__GETATTR                              0x00000004UL
@@ -49,7 +47,6 @@
 #define COMMON_IPC__ASSOCIATE                            0x00000040UL
 #define COMMON_IPC__UNIX_READ                            0x00000080UL
 #define COMMON_IPC__UNIX_WRITE                           0x00000100UL
-
 #define FILESYSTEM__MOUNT                         0x00000001UL
 #define FILESYSTEM__REMOUNT                       0x00000002UL
 #define FILESYSTEM__UNMOUNT                       0x00000004UL
@@ -60,7 +57,6 @@
 #define FILESYSTEM__ASSOCIATE                     0x00000080UL
 #define FILESYSTEM__QUOTAMOD                      0x00000100UL
 #define FILESYSTEM__QUOTAGET                      0x00000200UL
-
 #define DIR__IOCTL                                0x00000001UL
 #define DIR__READ                                 0x00000002UL
 #define DIR__WRITE                                0x00000004UL
@@ -78,13 +74,11 @@
 #define DIR__SWAPON                               0x00004000UL
 #define DIR__QUOTAON                              0x00008000UL
 #define DIR__MOUNTON                              0x00010000UL
-
 #define DIR__ADD_NAME                             0x00020000UL
 #define DIR__REMOVE_NAME                          0x00040000UL
 #define DIR__REPARENT                             0x00080000UL
 #define DIR__SEARCH                               0x00100000UL
 #define DIR__RMDIR                                0x00200000UL
-
 #define FILE__IOCTL                               0x00000001UL
 #define FILE__READ                                0x00000002UL
 #define FILE__WRITE                               0x00000004UL
@@ -102,11 +96,9 @@
 #define FILE__SWAPON                              0x00004000UL
 #define FILE__QUOTAON                             0x00008000UL
 #define FILE__MOUNTON                             0x00010000UL
-
 #define FILE__EXECUTE_NO_TRANS                    0x00020000UL
 #define FILE__ENTRYPOINT                          0x00040000UL
 #define FILE__EXECMOD                             0x00080000UL
-
 #define LNK_FILE__IOCTL                           0x00000001UL
 #define LNK_FILE__READ                            0x00000002UL
 #define LNK_FILE__WRITE                           0x00000004UL
@@ -124,7 +116,6 @@
 #define LNK_FILE__SWAPON                          0x00004000UL
 #define LNK_FILE__QUOTAON                         0x00008000UL
 #define LNK_FILE__MOUNTON                         0x00010000UL
-
 #define CHR_FILE__IOCTL                           0x00000001UL
 #define CHR_FILE__READ                            0x00000002UL
 #define CHR_FILE__WRITE                           0x00000004UL
@@ -142,11 +133,9 @@
 #define CHR_FILE__SWAPON                          0x00004000UL
 #define CHR_FILE__QUOTAON                         0x00008000UL
 #define CHR_FILE__MOUNTON                         0x00010000UL
-
 #define CHR_FILE__EXECUTE_NO_TRANS                0x00020000UL
 #define CHR_FILE__ENTRYPOINT                      0x00040000UL
 #define CHR_FILE__EXECMOD                         0x00080000UL
-
 #define BLK_FILE__IOCTL                           0x00000001UL
 #define BLK_FILE__READ                            0x00000002UL
 #define BLK_FILE__WRITE                           0x00000004UL
@@ -164,7 +153,6 @@
 #define BLK_FILE__SWAPON                          0x00004000UL
 #define BLK_FILE__QUOTAON                         0x00008000UL
 #define BLK_FILE__MOUNTON                         0x00010000UL
-
 #define SOCK_FILE__IOCTL                          0x00000001UL
 #define SOCK_FILE__READ                           0x00000002UL
 #define SOCK_FILE__WRITE                          0x00000004UL
@@ -182,7 +170,6 @@
 #define SOCK_FILE__SWAPON                         0x00004000UL
 #define SOCK_FILE__QUOTAON                        0x00008000UL
 #define SOCK_FILE__MOUNTON                        0x00010000UL
-
 #define FIFO_FILE__IOCTL                          0x00000001UL
 #define FIFO_FILE__READ                           0x00000002UL
 #define FIFO_FILE__WRITE                          0x00000004UL
@@ -200,9 +187,7 @@
 #define FIFO_FILE__SWAPON                         0x00004000UL
 #define FIFO_FILE__QUOTAON                        0x00008000UL
 #define FIFO_FILE__MOUNTON                        0x00010000UL
-
 #define FD__USE                                   0x00000001UL
-
 #define SOCKET__IOCTL                             0x00000001UL
 #define SOCKET__READ                              0x00000002UL
 #define SOCKET__WRITE                             0x00000004UL
@@ -225,7 +210,6 @@
 #define SOCKET__RECV_MSG                          0x00080000UL
 #define SOCKET__SEND_MSG                          0x00100000UL
 #define SOCKET__NAME_BIND                         0x00200000UL
-
 #define TCP_SOCKET__IOCTL                         0x00000001UL
 #define TCP_SOCKET__READ                          0x00000002UL
 #define TCP_SOCKET__WRITE                         0x00000004UL
@@ -248,13 +232,11 @@
 #define TCP_SOCKET__RECV_MSG                      0x00080000UL
 #define TCP_SOCKET__SEND_MSG                      0x00100000UL
 #define TCP_SOCKET__NAME_BIND                     0x00200000UL
-
 #define TCP_SOCKET__CONNECTTO                     0x00400000UL
 #define TCP_SOCKET__NEWCONN                       0x00800000UL
 #define TCP_SOCKET__ACCEPTFROM                    0x01000000UL
 #define TCP_SOCKET__NODE_BIND                     0x02000000UL
 #define TCP_SOCKET__NAME_CONNECT                  0x04000000UL
-
 #define UDP_SOCKET__IOCTL                         0x00000001UL
 #define UDP_SOCKET__READ                          0x00000002UL
 #define UDP_SOCKET__WRITE                         0x00000004UL
@@ -277,9 +259,7 @@
 #define UDP_SOCKET__RECV_MSG                      0x00080000UL
 #define UDP_SOCKET__SEND_MSG                      0x00100000UL
 #define UDP_SOCKET__NAME_BIND                     0x00200000UL
-
 #define UDP_SOCKET__NODE_BIND                     0x00400000UL
-
 #define RAWIP_SOCKET__IOCTL                       0x00000001UL
 #define RAWIP_SOCKET__READ                        0x00000002UL
 #define RAWIP_SOCKET__WRITE                       0x00000004UL
@@ -302,9 +282,7 @@
 #define RAWIP_SOCKET__RECV_MSG                    0x00080000UL
 #define RAWIP_SOCKET__SEND_MSG                    0x00100000UL
 #define RAWIP_SOCKET__NAME_BIND                   0x00200000UL
-
 #define RAWIP_SOCKET__NODE_BIND                   0x00400000UL
-
 #define NODE__TCP_RECV                            0x00000001UL
 #define NODE__TCP_SEND                            0x00000002UL
 #define NODE__UDP_RECV                            0x00000004UL
@@ -314,7 +292,6 @@
 #define NODE__ENFORCE_DEST                        0x00000040UL
 #define NODE__DCCP_RECV                           0x00000080UL
 #define NODE__DCCP_SEND                           0x00000100UL
-
 #define NETIF__TCP_RECV                           0x00000001UL
 #define NETIF__TCP_SEND                           0x00000002UL
 #define NETIF__UDP_RECV                           0x00000004UL
@@ -323,7 +300,6 @@
 #define NETIF__RAWIP_SEND                         0x00000020UL
 #define NETIF__DCCP_RECV                          0x00000040UL
 #define NETIF__DCCP_SEND                          0x00000080UL
-
 #define NETLINK_SOCKET__IOCTL                     0x00000001UL
 #define NETLINK_SOCKET__READ                      0x00000002UL
 #define NETLINK_SOCKET__WRITE                     0x00000004UL
@@ -346,7 +322,6 @@
 #define NETLINK_SOCKET__RECV_MSG                  0x00080000UL
 #define NETLINK_SOCKET__SEND_MSG                  0x00100000UL
 #define NETLINK_SOCKET__NAME_BIND                 0x00200000UL
-
 #define PACKET_SOCKET__IOCTL                      0x00000001UL
 #define PACKET_SOCKET__READ                       0x00000002UL
 #define PACKET_SOCKET__WRITE                      0x00000004UL
@@ -369,7 +344,6 @@
 #define PACKET_SOCKET__RECV_MSG                   0x00080000UL
 #define PACKET_SOCKET__SEND_MSG                   0x00100000UL
 #define PACKET_SOCKET__NAME_BIND                  0x00200000UL
-
 #define KEY_SOCKET__IOCTL                         0x00000001UL
 #define KEY_SOCKET__READ                          0x00000002UL
 #define KEY_SOCKET__WRITE                         0x00000004UL
@@ -392,7 +366,6 @@
 #define KEY_SOCKET__RECV_MSG                      0x00080000UL
 #define KEY_SOCKET__SEND_MSG                      0x00100000UL
 #define KEY_SOCKET__NAME_BIND                     0x00200000UL
-
 #define UNIX_STREAM_SOCKET__IOCTL                 0x00000001UL
 #define UNIX_STREAM_SOCKET__READ                  0x00000002UL
 #define UNIX_STREAM_SOCKET__WRITE                 0x00000004UL
@@ -415,11 +388,9 @@
 #define UNIX_STREAM_SOCKET__RECV_MSG              0x00080000UL
 #define UNIX_STREAM_SOCKET__SEND_MSG              0x00100000UL
 #define UNIX_STREAM_SOCKET__NAME_BIND             0x00200000UL
-
 #define UNIX_STREAM_SOCKET__CONNECTTO             0x00400000UL
 #define UNIX_STREAM_SOCKET__NEWCONN               0x00800000UL
 #define UNIX_STREAM_SOCKET__ACCEPTFROM            0x01000000UL
-
 #define UNIX_DGRAM_SOCKET__IOCTL                  0x00000001UL
 #define UNIX_DGRAM_SOCKET__READ                   0x00000002UL
 #define UNIX_DGRAM_SOCKET__WRITE                  0x00000004UL
@@ -442,7 +413,6 @@
 #define UNIX_DGRAM_SOCKET__RECV_MSG               0x00080000UL
 #define UNIX_DGRAM_SOCKET__SEND_MSG               0x00100000UL
 #define UNIX_DGRAM_SOCKET__NAME_BIND              0x00200000UL
-
 #define PROCESS__FORK                             0x00000001UL
 #define PROCESS__TRANSITION                       0x00000002UL
 #define PROCESS__SIGCHLD                          0x00000004UL
@@ -473,7 +443,6 @@
 #define PROCESS__EXECHEAP                         0x08000000UL
 #define PROCESS__SETKEYCREATE                     0x10000000UL
 #define PROCESS__SETSOCKCREATE                    0x20000000UL
-
 #define IPC__CREATE                               0x00000001UL
 #define IPC__DESTROY                              0x00000002UL
 #define IPC__GETATTR                              0x00000004UL
@@ -483,7 +452,6 @@
 #define IPC__ASSOCIATE                            0x00000040UL
 #define IPC__UNIX_READ                            0x00000080UL
 #define IPC__UNIX_WRITE                           0x00000100UL
-
 #define SEM__CREATE                               0x00000001UL
 #define SEM__DESTROY                              0x00000002UL
 #define SEM__GETATTR                              0x00000004UL
@@ -493,7 +461,6 @@
 #define SEM__ASSOCIATE                            0x00000040UL
 #define SEM__UNIX_READ                            0x00000080UL
 #define SEM__UNIX_WRITE                           0x00000100UL
-
 #define MSGQ__CREATE                              0x00000001UL
 #define MSGQ__DESTROY                             0x00000002UL
 #define MSGQ__GETATTR                             0x00000004UL
@@ -503,12 +470,9 @@
 #define MSGQ__ASSOCIATE                           0x00000040UL
 #define MSGQ__UNIX_READ                           0x00000080UL
 #define MSGQ__UNIX_WRITE                          0x00000100UL
-
 #define MSGQ__ENQUEUE                             0x00000200UL
-
 #define MSG__SEND                                 0x00000001UL
 #define MSG__RECEIVE                              0x00000002UL
-
 #define SHM__CREATE                               0x00000001UL
 #define SHM__DESTROY                              0x00000002UL
 #define SHM__GETATTR                              0x00000004UL
@@ -518,9 +482,7 @@
 #define SHM__ASSOCIATE                            0x00000040UL
 #define SHM__UNIX_READ                            0x00000080UL
 #define SHM__UNIX_WRITE                           0x00000100UL
-
 #define SHM__LOCK                                 0x00000200UL
-
 #define SECURITY__COMPUTE_AV                      0x00000001UL
 #define SECURITY__COMPUTE_CREATE                  0x00000002UL
 #define SECURITY__COMPUTE_MEMBER                  0x00000004UL
@@ -532,12 +494,10 @@
 #define SECURITY__SETBOOL                         0x00000100UL
 #define SECURITY__SETSECPARAM                     0x00000200UL
 #define SECURITY__SETCHECKREQPROT                 0x00000400UL
-
 #define SYSTEM__IPC_INFO                          0x00000001UL
 #define SYSTEM__SYSLOG_READ                       0x00000002UL
 #define SYSTEM__SYSLOG_MOD                        0x00000004UL
 #define SYSTEM__SYSLOG_CONSOLE                    0x00000008UL
-
 #define CAPABILITY__CHOWN                         0x00000001UL
 #define CAPABILITY__DAC_OVERRIDE                  0x00000002UL
 #define CAPABILITY__DAC_READ_SEARCH               0x00000004UL
@@ -569,110 +529,6 @@
 #define CAPABILITY__LEASE                         0x10000000UL
 #define CAPABILITY__AUDIT_WRITE                   0x20000000UL
 #define CAPABILITY__AUDIT_CONTROL                 0x40000000UL
-
-#define PASSWD__PASSWD                            0x00000001UL
-#define PASSWD__CHFN                              0x00000002UL
-#define PASSWD__CHSH                              0x00000004UL
-#define PASSWD__ROOTOK                            0x00000008UL
-#define PASSWD__CRONTAB                           0x00000010UL
-
-#define DRAWABLE__CREATE                          0x00000001UL
-#define DRAWABLE__DESTROY                         0x00000002UL
-#define DRAWABLE__DRAW                            0x00000004UL
-#define DRAWABLE__COPY                            0x00000008UL
-#define DRAWABLE__GETATTR                         0x00000010UL
-
-#define GC__CREATE                                0x00000001UL
-#define GC__FREE                                  0x00000002UL
-#define GC__GETATTR                               0x00000004UL
-#define GC__SETATTR                               0x00000008UL
-
-#define WINDOW__ADDCHILD                          0x00000001UL
-#define WINDOW__CREATE                            0x00000002UL
-#define WINDOW__DESTROY                           0x00000004UL
-#define WINDOW__MAP                               0x00000008UL
-#define WINDOW__UNMAP                             0x00000010UL
-#define WINDOW__CHSTACK                           0x00000020UL
-#define WINDOW__CHPROPLIST                        0x00000040UL
-#define WINDOW__CHPROP                            0x00000080UL
-#define WINDOW__LISTPROP                          0x00000100UL
-#define WINDOW__GETATTR                           0x00000200UL
-#define WINDOW__SETATTR                           0x00000400UL
-#define WINDOW__SETFOCUS                          0x00000800UL
-#define WINDOW__MOVE                              0x00001000UL
-#define WINDOW__CHSELECTION                       0x00002000UL
-#define WINDOW__CHPARENT                          0x00004000UL
-#define WINDOW__CTRLLIFE                          0x00008000UL
-#define WINDOW__ENUMERATE                         0x00010000UL
-#define WINDOW__TRANSPARENT                       0x00020000UL
-#define WINDOW__MOUSEMOTION                       0x00040000UL
-#define WINDOW__CLIENTCOMEVENT                    0x00080000UL
-#define WINDOW__INPUTEVENT                        0x00100000UL
-#define WINDOW__DRAWEVENT                         0x00200000UL
-#define WINDOW__WINDOWCHANGEEVENT                 0x00400000UL
-#define WINDOW__WINDOWCHANGEREQUEST               0x00800000UL
-#define WINDOW__SERVERCHANGEEVENT                 0x01000000UL
-#define WINDOW__EXTENSIONEVENT                    0x02000000UL
-
-#define FONT__LOAD                                0x00000001UL
-#define FONT__FREE                                0x00000002UL
-#define FONT__GETATTR                             0x00000004UL
-#define FONT__USE                                 0x00000008UL
-
-#define COLORMAP__CREATE                          0x00000001UL
-#define COLORMAP__FREE                            0x00000002UL
-#define COLORMAP__INSTALL                         0x00000004UL
-#define COLORMAP__UNINSTALL                       0x00000008UL
-#define COLORMAP__LIST                            0x00000010UL
-#define COLORMAP__READ                            0x00000020UL
-#define COLORMAP__STORE                           0x00000040UL
-#define COLORMAP__GETATTR                         0x00000080UL
-#define COLORMAP__SETATTR                         0x00000100UL
-
-#define PROPERTY__CREATE                          0x00000001UL
-#define PROPERTY__FREE                            0x00000002UL
-#define PROPERTY__READ                            0x00000004UL
-#define PROPERTY__WRITE                           0x00000008UL
-
-#define CURSOR__CREATE                            0x00000001UL
-#define CURSOR__CREATEGLYPH                       0x00000002UL
-#define CURSOR__FREE                              0x00000004UL
-#define CURSOR__ASSIGN                            0x00000008UL
-#define CURSOR__SETATTR                           0x00000010UL
-
-#define XCLIENT__KILL                             0x00000001UL
-
-#define XINPUT__LOOKUP                            0x00000001UL
-#define XINPUT__GETATTR                           0x00000002UL
-#define XINPUT__SETATTR                           0x00000004UL
-#define XINPUT__SETFOCUS                          0x00000008UL
-#define XINPUT__WARPPOINTER                       0x00000010UL
-#define XINPUT__ACTIVEGRAB                        0x00000020UL
-#define XINPUT__PASSIVEGRAB                       0x00000040UL
-#define XINPUT__UNGRAB                            0x00000080UL
-#define XINPUT__BELL                              0x00000100UL
-#define XINPUT__MOUSEMOTION                       0x00000200UL
-#define XINPUT__RELABELINPUT                      0x00000400UL
-
-#define XSERVER__SCREENSAVER                      0x00000001UL
-#define XSERVER__GETHOSTLIST                      0x00000002UL
-#define XSERVER__SETHOSTLIST                      0x00000004UL
-#define XSERVER__GETFONTPATH                      0x00000008UL
-#define XSERVER__SETFONTPATH                      0x00000010UL
-#define XSERVER__GETATTR                          0x00000020UL
-#define XSERVER__GRAB                             0x00000040UL
-#define XSERVER__UNGRAB                           0x00000080UL
-
-#define XEXTENSION__QUERY                         0x00000001UL
-#define XEXTENSION__USE                           0x00000002UL
-
-#define PAX__PAGEEXEC                             0x00000001UL
-#define PAX__EMUTRAMP                             0x00000002UL
-#define PAX__MPROTECT                             0x00000004UL
-#define PAX__RANDMMAP                             0x00000008UL
-#define PAX__RANDEXEC                             0x00000010UL
-#define PAX__SEGMEXEC                             0x00000020UL
-
 #define NETLINK_ROUTE_SOCKET__IOCTL               0x00000001UL
 #define NETLINK_ROUTE_SOCKET__READ                0x00000002UL
 #define NETLINK_ROUTE_SOCKET__WRITE               0x00000004UL
@@ -695,10 +551,8 @@
 #define NETLINK_ROUTE_SOCKET__RECV_MSG            0x00080000UL
 #define NETLINK_ROUTE_SOCKET__SEND_MSG            0x00100000UL
 #define NETLINK_ROUTE_SOCKET__NAME_BIND           0x00200000UL
-
 #define NETLINK_ROUTE_SOCKET__NLMSG_READ          0x00400000UL
 #define NETLINK_ROUTE_SOCKET__NLMSG_WRITE         0x00800000UL
-
 #define NETLINK_FIREWALL_SOCKET__IOCTL            0x00000001UL
 #define NETLINK_FIREWALL_SOCKET__READ             0x00000002UL
 #define NETLINK_FIREWALL_SOCKET__WRITE            0x00000004UL
@@ -721,10 +575,8 @@
 #define NETLINK_FIREWALL_SOCKET__RECV_MSG         0x00080000UL
 #define NETLINK_FIREWALL_SOCKET__SEND_MSG         0x00100000UL
 #define NETLINK_FIREWALL_SOCKET__NAME_BIND        0x00200000UL
-
 #define NETLINK_FIREWALL_SOCKET__NLMSG_READ       0x00400000UL
 #define NETLINK_FIREWALL_SOCKET__NLMSG_WRITE      0x00800000UL
-
 #define NETLINK_TCPDIAG_SOCKET__IOCTL             0x00000001UL
 #define NETLINK_TCPDIAG_SOCKET__READ              0x00000002UL
 #define NETLINK_TCPDIAG_SOCKET__WRITE             0x00000004UL
@@ -747,10 +599,8 @@
 #define NETLINK_TCPDIAG_SOCKET__RECV_MSG          0x00080000UL
 #define NETLINK_TCPDIAG_SOCKET__SEND_MSG          0x00100000UL
 #define NETLINK_TCPDIAG_SOCKET__NAME_BIND         0x00200000UL
-
 #define NETLINK_TCPDIAG_SOCKET__NLMSG_READ        0x00400000UL
 #define NETLINK_TCPDIAG_SOCKET__NLMSG_WRITE       0x00800000UL
-
 #define NETLINK_NFLOG_SOCKET__IOCTL               0x00000001UL
 #define NETLINK_NFLOG_SOCKET__READ                0x00000002UL
 #define NETLINK_NFLOG_SOCKET__WRITE               0x00000004UL
@@ -773,7 +623,6 @@
 #define NETLINK_NFLOG_SOCKET__RECV_MSG            0x00080000UL
 #define NETLINK_NFLOG_SOCKET__SEND_MSG            0x00100000UL
 #define NETLINK_NFLOG_SOCKET__NAME_BIND           0x00200000UL
-
 #define NETLINK_XFRM_SOCKET__IOCTL                0x00000001UL
 #define NETLINK_XFRM_SOCKET__READ                 0x00000002UL
 #define NETLINK_XFRM_SOCKET__WRITE                0x00000004UL
@@ -796,10 +645,8 @@
 #define NETLINK_XFRM_SOCKET__RECV_MSG             0x00080000UL
 #define NETLINK_XFRM_SOCKET__SEND_MSG             0x00100000UL
 #define NETLINK_XFRM_SOCKET__NAME_BIND            0x00200000UL
-
 #define NETLINK_XFRM_SOCKET__NLMSG_READ           0x00400000UL
 #define NETLINK_XFRM_SOCKET__NLMSG_WRITE          0x00800000UL
-
 #define NETLINK_SELINUX_SOCKET__IOCTL             0x00000001UL
 #define NETLINK_SELINUX_SOCKET__READ              0x00000002UL
 #define NETLINK_SELINUX_SOCKET__WRITE             0x00000004UL
@@ -822,7 +669,6 @@
 #define NETLINK_SELINUX_SOCKET__RECV_MSG          0x00080000UL
 #define NETLINK_SELINUX_SOCKET__SEND_MSG          0x00100000UL
 #define NETLINK_SELINUX_SOCKET__NAME_BIND         0x00200000UL
-
 #define NETLINK_AUDIT_SOCKET__IOCTL               0x00000001UL
 #define NETLINK_AUDIT_SOCKET__READ                0x00000002UL
 #define NETLINK_AUDIT_SOCKET__WRITE               0x00000004UL
@@ -845,12 +691,10 @@
 #define NETLINK_AUDIT_SOCKET__RECV_MSG            0x00080000UL
 #define NETLINK_AUDIT_SOCKET__SEND_MSG            0x00100000UL
 #define NETLINK_AUDIT_SOCKET__NAME_BIND           0x00200000UL
-
 #define NETLINK_AUDIT_SOCKET__NLMSG_READ          0x00400000UL
 #define NETLINK_AUDIT_SOCKET__NLMSG_WRITE         0x00800000UL
 #define NETLINK_AUDIT_SOCKET__NLMSG_RELAY         0x01000000UL
 #define NETLINK_AUDIT_SOCKET__NLMSG_READPRIV      0x02000000UL
-
 #define NETLINK_IP6FW_SOCKET__IOCTL               0x00000001UL
 #define NETLINK_IP6FW_SOCKET__READ                0x00000002UL
 #define NETLINK_IP6FW_SOCKET__WRITE               0x00000004UL
@@ -873,10 +717,8 @@
 #define NETLINK_IP6FW_SOCKET__RECV_MSG            0x00080000UL
 #define NETLINK_IP6FW_SOCKET__SEND_MSG            0x00100000UL
 #define NETLINK_IP6FW_SOCKET__NAME_BIND           0x00200000UL
-
 #define NETLINK_IP6FW_SOCKET__NLMSG_READ          0x00400000UL
 #define NETLINK_IP6FW_SOCKET__NLMSG_WRITE         0x00800000UL
-
 #define NETLINK_DNRT_SOCKET__IOCTL                0x00000001UL
 #define NETLINK_DNRT_SOCKET__READ                 0x00000002UL
 #define NETLINK_DNRT_SOCKET__WRITE                0x00000004UL
@@ -899,24 +741,10 @@
 #define NETLINK_DNRT_SOCKET__RECV_MSG             0x00080000UL
 #define NETLINK_DNRT_SOCKET__SEND_MSG             0x00100000UL
 #define NETLINK_DNRT_SOCKET__NAME_BIND            0x00200000UL
-
-#define DBUS__ACQUIRE_SVC                         0x00000001UL
-#define DBUS__SEND_MSG                            0x00000002UL
-
-#define NSCD__GETPWD                              0x00000001UL
-#define NSCD__GETGRP                              0x00000002UL
-#define NSCD__GETHOST                             0x00000004UL
-#define NSCD__GETSTAT                             0x00000008UL
-#define NSCD__ADMIN                               0x00000010UL
-#define NSCD__SHMEMPWD                            0x00000020UL
-#define NSCD__SHMEMGRP                            0x00000040UL
-#define NSCD__SHMEMHOST                           0x00000080UL
-
 #define ASSOCIATION__SENDTO                       0x00000001UL
 #define ASSOCIATION__RECVFROM                     0x00000002UL
 #define ASSOCIATION__SETCONTEXT                   0x00000004UL
 #define ASSOCIATION__POLMATCH                     0x00000008UL
-
 #define NETLINK_KOBJECT_UEVENT_SOCKET__IOCTL      0x00000001UL
 #define NETLINK_KOBJECT_UEVENT_SOCKET__READ       0x00000002UL
 #define NETLINK_KOBJECT_UEVENT_SOCKET__WRITE      0x00000004UL
@@ -939,7 +767,6 @@
 #define NETLINK_KOBJECT_UEVENT_SOCKET__RECV_MSG   0x00080000UL
 #define NETLINK_KOBJECT_UEVENT_SOCKET__SEND_MSG   0x00100000UL
 #define NETLINK_KOBJECT_UEVENT_SOCKET__NAME_BIND  0x00200000UL
-
 #define APPLETALK_SOCKET__IOCTL                   0x00000001UL
 #define APPLETALK_SOCKET__READ                    0x00000002UL
 #define APPLETALK_SOCKET__WRITE                   0x00000004UL
@@ -962,11 +789,9 @@
 #define APPLETALK_SOCKET__RECV_MSG                0x00080000UL
 #define APPLETALK_SOCKET__SEND_MSG                0x00100000UL
 #define APPLETALK_SOCKET__NAME_BIND               0x00200000UL
-
 #define PACKET__SEND                              0x00000001UL
 #define PACKET__RECV                              0x00000002UL
 #define PACKET__RELABELTO                         0x00000004UL
-
 #define KEY__VIEW                                 0x00000001UL
 #define KEY__READ                                 0x00000002UL
 #define KEY__WRITE                                0x00000004UL
@@ -974,10 +799,6 @@
 #define KEY__LINK                                 0x00000010UL
 #define KEY__SETATTR                              0x00000020UL
 #define KEY__CREATE                               0x00000040UL
-
-#define CONTEXT__TRANSLATE                        0x00000001UL
-#define CONTEXT__CONTAINS                         0x00000002UL
-
 #define DCCP_SOCKET__IOCTL                        0x00000001UL
 #define DCCP_SOCKET__READ                         0x00000002UL
 #define DCCP_SOCKET__WRITE                        0x00000004UL
diff --git a/security/selinux/include/class_to_string.h b/security/selinux/include/class_to_string.h
index 9f3ebb1..3787990 100644
--- a/security/selinux/include/class_to_string.h
+++ b/security/selinux/include/class_to_string.h
@@ -2,7 +2,7 @@
 /*
  * Security object class definitions
  */
-    S_("null")
+    S_(NULL)
     S_("security")
     S_("process")
     S_("system")
@@ -32,19 +32,19 @@
     S_("msgq")
     S_("shm")
     S_("ipc")
-    S_("passwd")
-    S_("drawable")
-    S_("window")
-    S_("gc")
-    S_("font")
-    S_("colormap")
-    S_("property")
-    S_("cursor")
-    S_("xclient")
-    S_("xinput")
-    S_("xserver")
-    S_("xextension")
-    S_("pax")
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
+    S_(NULL)
     S_("netlink_route_socket")
     S_("netlink_firewall_socket")
     S_("netlink_tcpdiag_socket")
@@ -54,12 +54,12 @@
     S_("netlink_audit_socket")
     S_("netlink_ip6fw_socket")
     S_("netlink_dnrt_socket")
-    S_("dbus")
-    S_("nscd")
+    S_(NULL)
+    S_(NULL)
     S_("association")
     S_("netlink_kobject_uevent_socket")
     S_("appletalk_socket")
     S_("packet")
     S_("key")
-    S_("context")
+    S_(NULL)
     S_("dccp_socket")
diff --git a/security/selinux/include/flask.h b/security/selinux/include/flask.h
index 67cef37..35f309f 100644
--- a/security/selinux/include/flask.h
+++ b/security/selinux/include/flask.h
@@ -34,19 +34,6 @@
 #define SECCLASS_MSGQ                                    27
 #define SECCLASS_SHM                                     28
 #define SECCLASS_IPC                                     29
-#define SECCLASS_PASSWD                                  30
-#define SECCLASS_DRAWABLE                                31
-#define SECCLASS_WINDOW                                  32
-#define SECCLASS_GC                                      33
-#define SECCLASS_FONT                                    34
-#define SECCLASS_COLORMAP                                35
-#define SECCLASS_PROPERTY                                36
-#define SECCLASS_CURSOR                                  37
-#define SECCLASS_XCLIENT                                 38
-#define SECCLASS_XINPUT                                  39
-#define SECCLASS_XSERVER                                 40
-#define SECCLASS_XEXTENSION                              41
-#define SECCLASS_PAX                                     42
 #define SECCLASS_NETLINK_ROUTE_SOCKET                    43
 #define SECCLASS_NETLINK_FIREWALL_SOCKET                 44
 #define SECCLASS_NETLINK_TCPDIAG_SOCKET                  45
@@ -56,14 +43,11 @@
 #define SECCLASS_NETLINK_AUDIT_SOCKET                    49
 #define SECCLASS_NETLINK_IP6FW_SOCKET                    50
 #define SECCLASS_NETLINK_DNRT_SOCKET                     51
-#define SECCLASS_DBUS                                    52
-#define SECCLASS_NSCD                                    53
 #define SECCLASS_ASSOCIATION                             54
 #define SECCLASS_NETLINK_KOBJECT_UEVENT_SOCKET           55
 #define SECCLASS_APPLETALK_SOCKET                        56
 #define SECCLASS_PACKET                                  57
 #define SECCLASS_KEY                                     58
-#define SECCLASS_CONTEXT                                 59
 #define SECCLASS_DCCP_SOCKET                             60
 
 /*
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 8ee4aae..d369856 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -1049,6 +1049,8 @@ static int validate_classes(struct policydb *p)
 
 	for (i = 1; i < kdefs->cts_len; i++) {
 		def_class = kdefs->class_to_string[i];
+		if (!def_class)
+			continue;
 		if (i > p->p_classes.nprim) {
 			printk(KERN_INFO
 			       "security:  class %s not defined in policy\n",
-- 
1.5.0.6

